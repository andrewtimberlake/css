require "spec_helper"

module CSS
  describe MarginProperty do
    context "As a long-hand property" do
      it "should store that value" do
        margin = Property.create('margin-left', 1.px)
        margin.left.should == 1.px
      end
    end

    context "Expanding CSS shorthand" do
      context "with all property values" do
        let(:margin) { Property.create('margin', '2px 3px 4px 5px;') }

        context "referencing long-hand properties" do
          it "should return the margin-top" do
            margin.top.should == 2.px
          end

          it "should return the margin-right" do
            margin.right.should == 3.px
          end

          it "should return the margin-bottom" do
            margin.bottom.should == 4.px
          end

          it "should return the margin-left" do
            margin.left.should == 5.px
          end
        end
      end

      context "with 3 property values" do
        let(:margin) { Property.create('margin', '3px 4px 5px;') }

        context "referencing long-hand properties" do
          it "should return the margin-top" do
            margin.top.should == 3.px
          end

          it "should return the margin-right" do
            margin.right.should == 4.px
          end

          it "should return the margin-bottom" do
            margin.bottom.should == 5.px
          end

          it "should return the margin-left" do
            margin.left.should == 4.px
          end
        end
      end

      context "with 2 property values" do
        let(:margin) { Property.create('margin', '4px 5px;') }

        context "referencing long-hand properties" do
          it "should return the margin-top" do
            margin.top.should == 4.px
          end

          it "should return the margin-right" do
            margin.right.should == 5.px
          end

          it "should return the margin-bottom" do
            margin.bottom.should == 4.px
          end

          it "should return the margin-left" do
            margin.left.should == 5.px
          end
        end
      end

      context "with 1 property value" do
        let(:margin) { Property.create('margin', '5px;') }

        context "referencing long-hand properties" do
          it "should return the margin-top" do
            margin.top.should == 5.px
          end

          it "should return the margin-right" do
            margin.right.should == 5.px
          end

          it "should return the margin-bottom" do
            margin.bottom.should == 5.px
          end

          it "should return the margin-left" do
            margin.left.should == 5.px
          end
        end
      end
    end

    context "methods: " do
      let(:margin) { Property.create('margin') }

      context "properties with different values" do
        before do
          margin.top = 1.em
          margin.right = 1.px
          margin.bottom = 2.percent
          margin.left = 3.5.ex
        end

        it "should respond to #to_style" do
          margin.to_style.should == 'margin:1em 1px 2% 3.5ex'
        end
      end

      context "properties with the same value" do
        before do
          margin.top = margin.right = margin.bottom = margin.left = 3.px
        end

        it "#to_style should return the short-hand" do
          margin.to_style.should == 'margin:3px'
        end
      end

      context "properties with the same value for top, bottom and left, right" do
        before do
          margin.top = margin.bottom = 3.gd
          margin.left = margin.right = 5.percent
        end

        it "#to_style should return the short-hand" do
          margin.to_style.should == 'margin:3gd 5%'
        end
      end

      context "properties with the same value for left and right" do
        before do
          margin.top = 3.px
          margin.bottom = 15.em
          margin.left = margin.right = 8.rem
        end

        it "#to_style should return the short-hand" do
          margin.to_style.should == 'margin:3px 8rem 15em'
        end
      end

      context "with only one property set" do
        before do
          margin.top = 15.px
        end

        it "#to_style should return the short-hand" do
          margin.to_style.should == 'margin-top:15px'
        end
      end

      context "with only two property set" do
        before do
          margin.top = 15.px
          margin.left = 5.em
        end

        it "#to_style should return the short-hand" do
          (margin.to_style.split(';') - 'margin-top:15px;margin-left:5em'.split(';')).should == []
        end
      end

      context "with only three property set" do
        before do
          margin.top = 15.px
          margin.left = 5.em
          margin.bottom = 3.gd
        end

        it "#to_style should return the short-hand" do
          (margin.to_style.split(';') - 'margin-top:15px;margin-bottom:3gd;margin-left:5em'.split(';')).should == []
        end
      end
    end

    context "merging properties" do
      let(:margin1) { Property.create('margin-left', 5.px) }
      let(:margin2) { Property.create('margin', 3.px) }

      before do
        margin1 << margin2
      end

      it "should add missing properties" do
        margin1.top.should == 3.px
      end

      it "should overwrite existing properties" do
        margin1.left.should == 3.px
      end
    end

    context "child properties" do
      let(:margin) { Property.create('margin', 3.px) }

      it "should return their full style name" do
        margin.top.to_style.should == 'margin-top:3px'
      end
    end
  end
end
