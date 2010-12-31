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

      %w(border outline border-left border-right border-top border-right).each do |property|
        context "#{property} property" do
          context "with all property values" do
            let(:rule) { Rule.new('#id', "#{property}: 2px solid red;") }

            context "referencing long-hand properties" do
              it "should return the #{property} size" do
                rule["#{property}_size"].should == '2px'
              end

              it "should return the #{property} style" do
                rule["#{property}_style"].should == 'solid'
              end

              it "should return the #{property} color" do
                rule["#{property}_color"].should == 'red'
              end
            end
          end

          context "with only size and style" do
            let(:rule) { Rule.new('#id', "#{property}: 5em dotted;") }

            context "referencing long-hand properties" do
              it "should return the #{property} size" do
                rule["#{property}_size"].should == '5em'
              end

              it "should return the #{property} style" do
                rule["#{property}_style"].should == 'dotted'
              end

              it "should return the #{property} color" do
                rule["#{property}_color"].should == 'black'
              end
            end
          end

          context "with only style" do
            let(:rule) { Rule.new('#id', "#{property}: dashed;") }

            context "referencing long-hand properties" do
              it "should return the #{property} size" do
                rule["#{property}_size"].should == '3px'
              end

              it "should return the #{property} style" do
                rule["#{property}_style"].should == 'dashed'
              end

              it "should return the #{property} color" do
                rule["#{property}_color"].should == 'black'
              end
            end
          end
        end
      end

      %w(margin padding).each do |property|
        context "#{property} property" do
          context "with all property values" do
            let(:rule) { Rule.new('#id', "#{property}: 2px 3px 4px 5px;") }

            context "referencing long-hand properties" do
              it "should return the #{property}-top" do
                rule["#{property}_top"].should == '2px'
              end

              it "should return the #{property}-right" do
                rule["#{property}_right"].should == '3px'
              end

              it "should return the #{property}-bottom" do
                rule["#{property}_bottom"].should == '4px'
              end

              it "should return the #{property}-left" do
                rule["#{property}_left"].should == '5px'
              end
            end
          end

          context "with 3 property values" do
            let(:rule) { Rule.new('#id', "#{property}: 3px 4px 5px;") }

            context "referencing long-hand properties" do
              it "should return the #{property}-top" do
                rule["#{property}_top"].should == '3px'
              end

              it "should return the #{property}-right" do
                rule["#{property}_right"].should == '4px'
              end

              it "should return the #{property}-bottom" do
                rule["#{property}_bottom"].should == '5px'
              end

              it "should return the #{property}-left" do
                rule["#{property}_left"].should == '4px'
              end
            end
          end

          context "with 2 property values" do
            let(:rule) { Rule.new('#id', "#{property}: 4px 5px;") }

            context "referencing long-hand properties" do
              it "should return the #{property}-top" do
                rule["#{property}_top"].should == '4px'
              end

              it "should return the #{property}-right" do
                rule["#{property}_right"].should == '5px'
              end

              it "should return the #{property}-bottom" do
                rule["#{property}_bottom"].should == '4px'
              end

              it "should return the #{property}-left" do
                rule["#{property}_left"].should == '5px'
              end
            end
          end

          context "with 1 property value" do
            let(:rule) { Rule.new('#id', "#{property}: 5px;") }

            context "referencing long-hand properties" do
              it "should return the #{property}-top" do
                rule["#{property}_top"].should == '5px'
              end

              it "should return the #{property}-right" do
                rule["#{property}_right"].should == '5px'
              end

              it "should return the #{property}-bottom" do
                rule["#{property}_bottom"].should == '5px'
              end

              it "should return the #{property}-left" do
                rule["#{property}_left"].should == '5px'
              end
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

      %w(border outline border-left border-right border-top border-right).each do |property|
        context "#{property} property" do
          let(:rule) { Rule.new('#id', "#{property}-size: 1em; #{property}-style: dotted; #{property}-color: rgba(127, 255, 64, 0.5);") }

          it "should return a short-hand version of the #{property} property" do
            rule[property].should == '1em dotted rgba(127, 255, 64, 0.5)'
          end
        end
      end

      %w(margin padding).each do |property|
        context "#{property} property with different values" do
          let(:rule) { Rule.new('#id', "#{property}-left: 1em; #{property}-top: 2em; #{property}-right: 4em; #{property}-bottom: 3em;") }

          it "should return a short-hand version of the #{property} property" do
            rule[property].should == '2em 4em 3em 1em'
          end
        end

        context "#{property} property with the same values" do
          let(:rule) { Rule.new('#id', "#{property}-left: 1em; #{property}-top: 1em; #{property}-right: 1em; #{property}-bottom: 1em;") }

          it "should return a short-hand version of the #{property} property" do
            rule[property].should == '1em'
          end
        end

        context "#{property} property with the same values for top, bottom and left, right" do
          let(:rule) { Rule.new('#id', "#{property}-left: 1em; #{property}-top: 2em; #{property}-right: 1em; #{property}-bottom: 2em;") }

          it "should return a short-hand version of the #{property} property" do
            rule[property].should == '2em 1em'
          end
        end

        context "#{property} property with the same values for left and right" do
          let(:rule) { Rule.new('#id', "#{property}-left: 1em; #{property}-top: 3em; #{property}-right: 1em; #{property}-bottom: 2em;") }

          it "should return a short-hand version of the #{property} property" do
            rule[property].should == '3em 1em 2em'
          end
        end
      end
    end
  end
end
