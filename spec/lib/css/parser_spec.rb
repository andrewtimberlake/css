require 'spec_helper'

module CSS
  describe Parser do
    context "parsing a CSS file" do
      let(:results) { Parser.new.parse(fixture('style.css')) }

      it "should provide access to individual rulesets by selector" do
        results['body'].to_s.should == 'color:#333333;background:black url(../images/background.jpg) fixed;margin:0;padding:5px'
      end

      it "should provide access to individual properties" do
        results['body']['color'] == '#333'
      end

      it "should match all selectors" do
        results.selectors.should == ['body', '#logo', '#container', '#content', '#menu', '#menu ul', '#menu ul li', '#menu ul li a', '#menu ul li a:hover']
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
  end
end
