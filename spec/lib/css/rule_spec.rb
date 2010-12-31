require "spec_helper"

module CSS
  describe Rule do
    let(:rule) { Rule.new('#id', 'background-color:#333;color:#FFF') }

    it "should return a property by name" do
      rule['color'].should == '#FFF'
    end

    it "should return a property reference with a symbol" do
      rule[:color].should == '#FFF'
    end

    it "should allow referencing a property as a method call" do
      rule.color.should == '#FFF'
    end

    it "should allow referencing a hyphenated property by camel-case method name" do
      rule.backgroundColor.should == '#333'
    end

    context "Expanding CSS shorthand" do
      context "background property" do
        context "with all property values" do
          let(:rule) { Rule.new('#id', 'background: #FFF url(image.png) no-repeat 20px 100px fixed;') }

          context "referencing long-hand properties" do
            it "should return the background color" do
              rule.backgroundColor.should == '#FFF'
            end

            it "should return the background image" do
              rule.backgroundImage.should == 'url(image.png)'
            end

            it "should return the background repeat" do
              rule.backgroundRepeat.should == 'no-repeat'
            end

            it "should return the background position" do
              rule.backgroundPosition.should == '20px 100px'
            end

            it "should return the background attachment" do
              rule.backgroundAttachment.should == 'fixed'
            end
          end
        end

        context "with partial property values" do
          let(:rule) { Rule.new('#id', 'background: url(image.png) 20px 100px inherit;') }

          context "referencing long-hand properties" do
            it "should return the background color" do
              rule.backgroundColor.should == 'transparent'
            end

            it "should return the background image" do
              rule.backgroundImage.should == 'url(image.png)'
            end

            it "should return the background repeat" do
              rule.backgroundRepeat.should == 'repeat'
            end

            it "should return the background position" do
              rule.backgroundPosition.should == '20px 100px'
            end

            it "should return the background attachment" do
              rule.backgroundAttachment.should == 'inherit'
            end
          end
        end

        context "with a color name" do
          let(:rule) { Rule.new('#id', 'background: black') }

          context "referencing long-hand properties" do
            it "should return the background color" do
              rule.backgroundColor.should == 'black'
            end
          end
        end
      end
    end

    context "Compacting CSS properties" do
      context "background property" do
        let(:rule) { Rule.new('#id', 'background-image: url(image.png);background-position: top center; background-attachment:inherit;') }

        it "should return a short-hand version of the background property" do
          rule.background.should == 'url(image.png) top center inherit'
        end
      end
    end
  end
end
