require "spec_helper"

module CSS
  describe BackgroundProperty do
    context "Expanding CSS shorthand" do
      context "with all property values" do
        let(:background) { Property.create('background', '#FFF url(image.png) no-repeat 20px 100px fixed;') }

        context "referencing long-hand properties" do
          it "should return the background color" do
            background.color.should == '#FFF'
          end

          it "should return the background image" do
            background.image.should == 'url(image.png)'
          end

          it "should return the background repeat" do
            background.repeat.should == 'no-repeat'
          end

          it "should return the background position" do
            background.position.should == '20px 100px'
          end

          it "should return the background attachment" do
            background.attachment.should == 'fixed'
          end
        end
      end

      context "with partial property values" do
        let(:background) { Property.create('background', 'url(image.png) 20px 100px inherit;') }

        context "referencing long-hand properties" do
          it "should return the background color" do
            background.color.should == 'transparent'
          end

          it "should return the background image" do
            background.image.should == 'url(image.png)'
          end

          it "should return the background repeat" do
            background.repeat.should == 'repeat'
          end

          it "should return the background position" do
            background.position.should == '20px 100px'
          end

          it "should return the background attachment" do
            background.attachment.should == 'inherit'
          end
        end
      end

      context "with a color name" do
        let(:background) { Property.create('background', 'black') }

        context "referencing long-hand properties" do
          it "should return the background color" do
            background.color.should == 'black'
          end
        end
      end

      context "methods: " do
        let(:background) { Property.create('background') }

        before do
          background.image = 'url(image.png)'
          background.position = 'top center'
          background.attachment = 'inherit'
        end

        it "#value should return a short-hand version of the background property" do
          background.value.should == 'url(image.png) top center inherit'
        end

        it "#to_s should return the full property syntax" do
          background.to_s.should == 'background:url(image.png) top center inherit'
        end
      end
    end
  end
end
