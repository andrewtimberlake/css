require "spec_helper"

module CSS
  describe PaddingProperty do
    context "As a long-hand property" do
      it "should store that value" do
        padding = Property.create('padding-left', 1.px)
        padding.left.should == 1.px
      end
    end

    context "Expanding CSS shorthand" do
      context "with all property values" do
        let(:padding) { Property.create('padding', '2px 3px 4px 5px;') }

        context "referencing long-hand properties" do
          it "should return the padding-top" do
            padding.top.should == 2.px
          end

          it "should return the padding-right" do
            padding.right.should == 3.px
          end

          it "should return the padding-bottom" do
            padding.bottom.should == 4.px
          end

          it "should return the padding-left" do
            padding.left.should == 5.px
          end
        end
      end

      context "with 3 property values" do
        let(:padding) { Property.create('padding', '3px 4px 5px;') }

        context "referencing long-hand properties" do
          it "should return the padding-top" do
            padding.top.should == 3.px
          end

          it "should return the padding-right" do
            padding.right.should == 4.px
          end

          it "should return the padding-bottom" do
            padding.bottom.should == 5.px
          end

          it "should return the padding-left" do
            padding.left.should == 4.px
          end
        end
      end

      context "with 2 property values" do
        let(:padding) { Property.create('padding', '4px 5px;') }

        context "referencing long-hand properties" do
          it "should return the padding-top" do
            padding.top.should == 4.px
          end

          it "should return the padding-right" do
            padding.right.should == 5.px
          end

          it "should return the padding-bottom" do
            padding.bottom.should == 4.px
          end

          it "should return the padding-left" do
            padding.left.should == 5.px
          end
        end
      end

      context "with 1 property value" do
        let(:padding) { Property.create('padding', '5px;') }

        context "referencing long-hand properties" do
          it "should return the padding-top" do
            padding.top.should == 5.px
          end

          it "should return the padding-right" do
            padding.right.should == 5.px
          end

          it "should return the padding-bottom" do
            padding.bottom.should == 5.px
          end

          it "should return the padding-left" do
            padding.left.should == 5.px
          end
        end
      end
    end

    context "methods: " do
      let(:padding) { Property.create('padding') }

      context "properties with different values" do
        before do
          padding.top = 1.em
          padding.right = 1.px
          padding.bottom = 2.percent
          padding.left = 3.5.ex
        end

        it "should respond to #to_s" do
          padding.to_s.should == '1em 1px 2% 3.5ex'
        end

        it "should respond to #to_style" do
          padding.to_style.should == 'padding:1em 1px 2% 3.5ex'
        end
      end

      context "properties with the same value" do
        before do
          padding.top = padding.right = padding.bottom = padding.left = 3.px
        end

        it "#to_style should return the short-hand" do
          padding.to_style.should == 'padding:3px'
        end
      end

      context "properties with the same value for top, bottom and left, right" do
        before do
          padding.top = padding.bottom = 3.gd
          padding.left = padding.right = 5.percent
        end

        it "#to_style should return the short-hand" do
          padding.to_style.should == 'padding:3gd 5%'
        end
      end

      context "properties with the same value for left and right" do
        before do
          padding.top = 3.px
          padding.bottom = 15.em
          padding.left = padding.right = 8.rem
        end

        it "#to_style should return the short-hand" do
          padding.to_style.should == 'padding:3px 8rem 15em'
        end
      end

      context "with only one property set" do
        before do
          padding.top = 15.px
        end

        it "#to_style should return the short-hand" do
          padding.to_style.should == 'padding-top:15px'
        end
      end

      context "with only two property set" do
        before do
          padding.top = 15.px
          padding.left = 5.em
        end

        it "#to_style should return the short-hand" do
          (padding.to_style.split(';') - 'padding-top:15px;padding-left:5em'.split(';')).should == []
        end
      end

      context "with only three property set" do
        before do
          padding.top = 15.px
          padding.left = 5.em
          padding.bottom = 3.gd
        end

        it "#to_style should return the short-hand" do
          (padding.to_style.split(';') - 'padding-top:15px;padding-bottom:3gd;padding-left:5em'.split(';')).should == []
        end
      end
    end

    context "merging properties" do
      let(:padding1) { Property.create('padding-left', 5.px) }
      let(:padding2) { Property.create('padding', 3.px) }

      before do
        padding1 << padding2
      end

      it "should add missing properties" do
        padding1.top.should == 3.px
      end

      it "should overwrite existing properties" do
        padding1.left.should == 3.px
      end
    end

    context "child properties" do
      let(:padding) { Property.create('padding', 5.em) }

      it "should return their full style name" do
        padding.left.to_style.should == 'padding-left:5em'
      end
    end
  end
end
