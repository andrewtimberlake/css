require "spec_helper"

module CSS
  describe OutlineProperty do
    context "As a long-hand property" do
      it "should store that value" do
        outline = Property.create('outline-color', '#FFF')
        outline.color.should == '#FFF'
      end
    end

    context "Expanding CSS shorthand" do
      context "with all property values" do
        let(:outline) { Property.create('outline', '2px solid red;') }

        context "referencing long-hand properties" do
          it "should return the outline size" do
            outline.size.should == '2px'
          end

          it "should return the outline style" do
            outline.style.should == 'solid'
          end

          it "should return the outline color" do
            outline.color.should == 'red'
          end
        end
      end

      context "with only size and style" do
        let(:outline) { Property.create('outline', '5em dotted;') }

        context "referencing long-hand properties" do
          it "should return the outline size" do
            outline.size.should == '5em'
          end

          it "should return the outline style" do
            outline.style.should == 'dotted'
          end

          it "should return the outline color" do
            outline.color.should be_nil
          end
        end
      end

      context "with only style" do
        let(:outline) { Property.create('outline', 'dashed;') }

        context "referencing long-hand properties" do
          it "should return the outline size" do
            outline.size.should be_nil
          end

          it "should return the outline style" do
            outline.style.should == 'dashed'
          end

          it "should return the outline color" do
            outline.color.should be_nil
          end
        end
      end
    end

    context "methods: " do
      let(:outline) { Property.create('outline') }

      before do
        outline.size = '1em'
        outline.style = 'dotted'
        outline.color = 'rgba(127, 255, 64, 0.5)'
      end

      it "#to_s should return the full property syntax" do
        outline.to_s.should == 'outline:1em dotted rgba(127, 255, 64, 0.5)'
      end
    end

    context "merging properties" do
      let(:outline1) { Property.create('outline-style', 'dashed') }
      let(:outline2) { Property.create('outline', '1px dotted #333') }

      before do
        outline1 << outline2
      end

      it "should add missing properties" do
        outline1.size.should == 1.px
      end

      it "should overwrite existing properties" do
        outline1.style.should == 'dotted'
      end
    end
  end
end
