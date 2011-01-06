require "spec_helper"

module CSS
  describe FontProperty do
    context "As a long-hand property" do
      it "should store that value" do
        font = Property.create('font-family', 'Arial')
        font.family.should == 'Arial'
      end
    end

    context "Expanding CSS shorthand" do
      context "with all property values" do
        let(:font) { Property.create('font', 'italic small-caps bold 1em/1.2em georgia,"times new roman",serif;') }

        context "referencing long-hand properties" do
          it "should return the font style" do
            font.style.should == 'italic'
          end

          it "should return the font variant" do
            font.variant.should == 'small-caps'
          end

          it "should return the font weight" do
            font.weight.should == 'bold'
          end

          it "should return the font size" do
            font.size.should == '1em'
          end

          it "should returbn the line height" do
            font.line_height.should == '1.2em'
          end

          it "should return the font family" do
            font.family.should == 'georgia,"times new roman",serif'
          end
        end
      end

      context "with only font size and font family" do
        let(:font) { Property.create('font', '12px arial;') }

        context "referencing long-hand properties" do
          it "should return the font size" do
            font.size.should == '12px'
          end

          it "should return the font family" do
            font.family.should == 'arial'
          end
        end
      end

      context "with only only property other than font size and font family" do
        let(:font) { Property.create('font', 'inherit 80% georgia,"times roman",sans-serif;') }

        context "referencing long-hand properties" do
          it "should return the font size" do
            font.size.should == '80%'
          end

          it "should return the font family" do
            font.family.should == 'georgia,"times roman",sans-serif'
          end

          it "should return the font style" do
            font.style.should == 'inherit'
          end
        end
      end
    end

    context "methods: " do
      let(:font) { Property.create('font') }

      before do
        font.size = '12em'
        font.weight = 'bold'
        font.family = 'arial'
        font.line_height = '1.2em'
      end

      it "should respond to #to_s" do
        font.to_s.should == 'bold 12em/1.2em arial'
      end

      it "should respond to #to_style" do
        font.to_style.should == 'font:bold 12em/1.2em arial'
      end
    end

    context "merging properties" do
      let(:font1) { Property.create('font', '12px arial') }
      let(:font2) { Property.create('font', 'bold 11px/1.5em "times roman"') }

      before do
        font1 << font2
      end

      it "should add missing properties" do
        font1.weight.should == 'bold'
      end

      it "should overwrite existing properties" do
        font1.size.should == 11.px
        font1.line_height.should == 1.5.em
      end
    end

    context "line-height" do
      context "on it's own" do
        let(:font) { Property.create('line-height', 1.2.em) }

        it "should return a font property" do
          font.should be_a(FontProperty)
        end

        it "should return the line height" do
          font.line_height.should == 1.2.em
        end

        it "should output the line-height property" do
          font.to_style.should == 'line-height:1.2em'
        end
      end

      context "with font size" do
        let(:font) { Property.create('font') }

        before do
          font.line_height = 1.3.em
          font.size = 12.px
        end

        it "should output in two long-format properties" do
          font.to_style.should == 'font-size:12px;line-height:1.3em'
        end
      end
    end

    context "child properties" do
      let(:font) { Property.create('font', '24px/1.5em arial') }

      it "should return their full style name" do
        font.size.to_style.should == 'font-size:24px'
        font.line_height.to_style.should == 'line-height:1.5em'
      end
    end
  end
end
