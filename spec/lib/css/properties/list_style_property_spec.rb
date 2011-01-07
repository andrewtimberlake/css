require "spec_helper"

module CSS
  describe ListStyleProperty do
    context "As a long-hand property" do
      it "should store that value" do
        list_style = Property.create('list-style-type', 'square')
        list_style.type.should == 'square'
      end
    end

    context "Expanding CSS shorthand" do
      context "with all property values" do
        let(:list_style) { Property.create('list-style', 'square inside url(image.png);') }

        context "referencing long-hand properties" do
          it "should return the list-style-type" do
            list_style.type.should == 'square'
          end

          it "should return the list-style-position" do
            list_style.position.should == 'inside'
          end

          it "should return the list-style-image" do
            list_style.image.should == 'url(image.png)'
          end
        end
      end

      context "with just type and style" do
        let(:list_style) { Property.create('list-style', 'square inside;') }

        context "referencing long-hand properties" do
          it "should return the list-style-type" do
            list_style.type.should == 'square'
          end

          it "should return the list-style-position" do
            list_style.position.should == 'inside'
          end

          it "should return the list-style-image" do
            list_style.image.should == 'none'
          end
        end
      end

      context "with just style" do
        let(:list_style) { Property.create('list-style', 'square inside;') }

        context "referencing long-hand properties" do
          it "should return the list-style-type" do
            list_style.type.should == 'square'
          end

          it "should return the list-style-position" do
            list_style.position.should == 'inside'
          end

          it "should return the list-style-image" do
            list_style.image.should == 'none'
          end
        end
      end
    end

    context "methods: " do
      let(:list_style) { Property.create('list-style') }

      context "with all property values" do
        before do
          list_style.type = 'square'
          list_style.position = 'inside'
          list_style.image = 'url(image.png)'
        end

        it "should respond to #to_style" do
          list_style.to_style.should == 'list-style:square inside url(image.png)'
        end
      end

      context "with only 2 property values" do
        before do
          list_style.type = 'square'
          list_style.position = 'inside'
        end

        it "#to_style should return the short-hand" do
          list_style.to_style.should == 'list-style:square inside none'
        end
      end
    end

    context "merging properties" do
      let(:list_style1) { Property.create('list-style-type', 'square') }
      let(:list_style2) { Property.create('list-style', 'circle inside url(image.png)') }

      before do
        list_style1 << list_style2
      end

      it "should add missing properties" do
        list_style1.position.should == 'inside'
      end

      it "should overwrite existing properties" do
        list_style1.type.should == 'circle'
      end
    end

    context "child properties" do
      let(:list_style) { Property.create('list-style', 'circle inside url(image.png)') }

      it "should return their full style name" do
        list_style.image.to_style.should == 'list-style-image:url(image.png)'
      end
    end
  end
end
