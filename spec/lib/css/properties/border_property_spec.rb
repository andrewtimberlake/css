require "spec_helper"

module CSS
  describe BorderProperty do
    context "As a long-hand property" do
      it "should store that value" do
        border = Property.create('border-color', '#FFF')
        border.color.should == '#FFF'
      end
    end

    context "Expanding CSS shorthand" do
      context "with all property values" do
        let(:border) { Property.create('border', '2px solid red;') }

        context "referencing long-hand properties" do
          it "should return the border size" do
            border.size.should == '2px'
          end

          it "should return the border style" do
            border.style.should == 'solid'
          end

          it "should return the border color" do
            border.color.should == 'red'
          end
        end
      end

      context "with only size and style" do
        let(:border) { Property.create('border', '5em dotted;') }

        context "referencing long-hand properties" do
          it "should return the border size" do
            border.size.should == '5em'
          end

          it "should return the border style" do
            border.style.should == 'dotted'
          end

          it "should return the border color" do
            border.color.should be_nil
          end
        end
      end

      context "with only style" do
        let(:border) { Property.create('border', 'dashed;') }

        context "referencing long-hand properties" do
          it "should return the border size" do
            border.size.should be_nil
          end

          it "should return the border style" do
            border.style.should == 'dashed'
          end

          it "should return the border color" do
            border.color.should be_nil
          end
        end
      end

      context "with only size" do
        let(:border) { Property.create('border', '1px;') }

        context "referencing long-hand properties" do
          it "should return the border size" do
            border.size.should == '1px'
          end

          it "should return the border style" do
            border.style.should == nil
          end

          it "should return the border color" do
            border.color.should be_nil
          end
        end
      end
    end

    context "methods: " do
      let(:border) { Property.create('border') }

      context "with all property values" do
        before do
          border.size = '1em'
          border.style = 'dotted'
          border.color = 'rgba(127, 255, 64, 0.5)'
        end

        it "should respond to #to_s" do
          border.to_s.should == '1em dotted rgba(127, 255, 64, 0.5)'
        end

        it "should respond to #inspect" do
          border.to_s.should == '1em dotted rgba(127, 255, 64, 0.5)'
        end

        it "should respond to #to_style" do
          border.to_style.should == 'border:1em dotted rgba(127, 255, 64, 0.5)'
        end
      end

      context "with only size and style" do
        before do
          border.size = '1em'
          border.style = 'dotted'
        end

        it "#to_s should return the full property syntax" do
          border.to_style.should == 'border:1em dotted'
        end
      end

      context "with only size" do
        before do
          border.size = '1em'
        end

        it "#to_s should return the full property syntax" do
          border.to_style.should == 'border-size:1em'
        end
      end
    end

    context "merging properties" do
      let(:border1) { Property.create('border-style', 'dashed') }
      let(:border2) { Property.create('border', '1px dotted #333') }

      before do
        border1 << border2
      end

      it "should add missing properties" do
        border1.size.should == 1.px
      end

      it "should overwrite existing properties" do
        border1.style.should == 'dotted'
      end
    end

    context "child properties" do
      let(:border) { Property.create('border', '2px dotted red') }

      it "should return their full style name" do
        border.color.to_style.should == 'border-color:red'
      end
    end

    context "border sides" do
      let(:border) { Property.create('border', '1px dashed #808080') }

      it "should return the values for the top" do
        border.top.color.should == '#808080'
      end

      it "should return the values for the left" do
        border.left.style.should == 'dashed'
      end

      it "should return the values for the bottom" do
        border.bottom.size.should == 1.px
      end

      it "should return the values for the right" do
        border.right.size.should == 1.px
      end

      context "with different borders on each side" do
        before do
          border.top.color = 'red'
          border.right.color = 'yellow'
          border.bottom.color = 'blue'
          border.left.color = 'green'

          border.top.size = 2.ex
          border.right.size = 3.em
          border.bottom.size = 4.px
          border.left.size = 5.percent

          border.top.style = 'inset'
          border.right.style = 'dashed'
          border.bottom.style = 'dotted'
          border.left.style = 'double'
        end

        it "should return sides in #to_style" do
          border.to_style.should == 'border-top:2ex inset red;border-right:3em dashed yellow;border-bottom:4px dotted blue;border-left:5% double green'
        end
      end

      context "with just a single side" do
        let(:css) { Parser.parse("div { border-top: 2px solid red }") }
        let(:border) { css['div'].border }

        it "should return just that side in #to_style" do
          border.to_style.should == "border-top:2px solid red"
        end
      end
    end
  end
end
