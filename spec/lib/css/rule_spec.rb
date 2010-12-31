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
      rule.background_color.should == '#333'
    end

    context "Expanding CSS shorthand" do
      context "background property" do
        context "with all property values" do
          let(:rule) { Rule.new('#id', 'background: #FFF url(image.png) no-repeat 20px 100px fixed;') }

          context "referencing long-hand properties" do
            it "should return the background color" do
              rule.background_color.should == '#FFF'
            end

            it "should return the background image" do
              rule.background_image.should == 'url(image.png)'
            end

            it "should return the background repeat" do
              rule.background_repeat.should == 'no-repeat'
            end

            it "should return the background position" do
              rule.background_position.should == '20px 100px'
            end

            it "should return the background attachment" do
              rule.background_attachment.should == 'fixed'
            end
          end
        end

        context "with partial property values" do
          let(:rule) { Rule.new('#id', 'background: url(image.png) 20px 100px inherit;') }

          context "referencing long-hand properties" do
            it "should return the background color" do
              rule.background_color.should == 'transparent'
            end

            it "should return the background image" do
              rule.background_image.should == 'url(image.png)'
            end

            it "should return the background repeat" do
              rule.background_repeat.should == 'repeat'
            end

            it "should return the background position" do
              rule.background_position.should == '20px 100px'
            end

            it "should return the background attachment" do
              rule.background_attachment.should == 'inherit'
            end
          end
        end

        context "with a color name" do
          let(:rule) { Rule.new('#id', 'background: black') }

          context "referencing long-hand properties" do
            it "should return the background color" do
              rule.background_color.should == 'black'
            end
          end
        end
      end

      context "font property" do
        context "with all property values" do
          let(:rule) { Rule.new('#id', 'font: italic small-caps bold 1em/1.2em georgia,"times new roman",serif;') }

          context "referencing long-hand properties" do
            it "should return the font style" do
              rule.font_style.should == 'italic'
            end

            it "should return the font variant" do
              rule.font_variant.should == 'small-caps'
            end

            it "should return the font weight" do
              rule.font_weight.should == 'bold'
            end

            it "should return the font size" do
              rule.font_size.should == '1em'
            end

            it "should returbn the line height" do
              rule.line_height.should == '1.2em'
            end

            it "should return the font family" do
              rule.font_family.should == 'georgia,"times new roman",serif'
            end
          end
        end

        context "with only font size and font family" do
          let(:rule) { Rule.new('#id', 'font: 12px arial;') }

          context "referencing long-hand properties" do
            it "should return the font size" do
              rule.font_size.should == '12px'
            end

            it "should return the font family" do
              rule.font_family.should == 'arial'
            end
          end
        end

        context "with only only property other than font size and font family" do
          let(:rule) { Rule.new('#id', 'font: inherit 80% georgia,"times roman",sans-serif;') }

          context "referencing long-hand properties" do
            it "should return the font size" do
              rule.font_size.should == '80%'
            end

            it "should return the font family" do
              rule.font_family.should == 'georgia,"times roman",sans-serif'
            end

            it "should return the font style" do
              rule.font_style.should == 'inherit'
            end
          end
        end
      end

      context "border property" do
        context "with all property values" do
          let(:rule) { Rule.new('#id', 'border: 2px solid red;') }

          context "referencing long-hand properties" do
            it "should return the border size" do
              rule.border_size.should == '2px'
            end

            it "should return the border style" do
              rule.border_style.should == 'solid'
            end

            it "should return the border color" do
              rule.border_color.should == 'red'
            end
          end
        end

        context "with only size and style" do
          let(:rule) { Rule.new('#id', 'border: 5em dotted;') }

          context "referencing long-hand properties" do
            it "should return the border size" do
              rule.border_size.should == '5em'
            end

            it "should return the border style" do
              rule.border_style.should == 'dotted'
            end

            it "should return the border color" do
              rule.border_color.should == 'black'
            end
          end
        end

        context "with only style" do
          let(:rule) { Rule.new('#id', 'border: dashed;') }

          context "referencing long-hand properties" do
            it "should return the border size" do
              rule.border_size.should == '3px'
            end

            it "should return the border style" do
              rule.border_style.should == 'dashed'
            end

            it "should return the border color" do
              rule.border_color.should == 'black'
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

      context "font property" do
        let(:rule) { Rule.new('#id', 'font-size: 12em; font-weight: bold; font-family: arial; line-height: 1.2em') }

        it "should return a short-hand version of the font property" do
          rule.font.should == 'bold 12em/1.2em arial'
        end
      end

      context "border property" do
        let(:rule) { Rule.new('#id', 'border-size: 1em; border-style: dotted; border-color: rgba(127, 255, 64, 0.5);') }

        it "should return a short-hand version of the border property" do
          rule.border.should == '1em dotted rgba(127, 255, 64, 0.5)'
        end
      end
    end
  end
end
