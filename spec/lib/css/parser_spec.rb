require 'spec_helper'

module CSS
  describe Parser do
    context "parsing a CSS file" do
      let(:css) { Parser.parse(fixture('style.css')) }

      it "should provide access to individual rulesets by selector" do
        (css['body'].to_s.split(/;/) - 'color:#333333;background:black url(../images/background.jpg) fixed;margin:0;padding:5px'.split(/;/)).should == []
      end

      it "should provide access to individual properties" do
        css['body']['color'] == '#333'
      end

      it "should match all selectors" do
        css.selectors.should == ['body', '#logo', '#container', '#content', '#menu', '#menu ul', '#menu ul li', '#menu ul li a', '#menu ul li a:hover']
      end
    end

    context "parsing a CSS string" do
      let(:style) { "body { background: #FFF url('image.png') no-repeat; color: #333 }" }
      let(:css) { Parser.new.parse(style) }

      it "should return the body background color" do
        css['body'].backgroundColor.should == '#FFF'
      end
    end

    context "parsing an open file" do
      let(:css) do
        css = nil
        parser = Parser.new
        File.open(fixture('style.css')) do |file|
          css = parser.parse(file)
        end
        css
      end

      it "should return the body background color" do
        css['body'].color.should == '#333333'
      end
    end

    context "parsing two styles one after each other" do
      it "should be able to parse both successfully" do
        parser = Parser.new
        css1 = parser.parse("body { color: #333 }")
        css2 = parser.parse("body { color: #FFF }")

        css1['body'].color.should == '#333'
        css2['body'].color.should == '#FFF'
      end
    end

    context "Comma separated selectors" do
      let(:css) { Parser.parse("h1,h2 { font-size: 14px; }") }

      it "should resolve into a rule per selector" do
        css["h1"].font_size.should == "14px"
        css["h2"].font_size.should == "14px"
      end
    end

    context "A failing parse" do
      let(:error) do
        error = nil
        begin
          Parser.new.parse(fixture('failing.css'))
        rescue CSSError => e
          error = e
        end
        error
      end

      it "should raise an error" do
        error.should be_a(CSSError)
      end

      it "should return the line number of the failure" do
        error.line_number.should == 7
      end

      it "should return the character of the failure" do
        error.char.should == 7
      end

      it "should return the reason for the error" do
      end
    end

    context "Overwriting rules" do
      let(:css) { Parser.new.parse(fixture('overwriting.css')) }

      it "should only have a single paragraph selector" do
        css.selectors.should == ['p', 'h1', 'h2']
      end

      it "should have a paragraph with a border of 1px" do
        css['p'].border.size.should == 1.px
      end

      it "should have a header 1 with a bottom margin larger than the other margins" do
        css['h1'].margin.to_style.should == 'margin:3px 3px 1em'
      end

      it "should have a header 2 with the same padding all around" do
        css['h2'].padding.to_style.should == 'padding:3px'
      end
    end
  end
end
