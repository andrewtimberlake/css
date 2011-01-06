require "spec_helper"

module CSS
  describe Property do
    it "should not allow creation of a property via new" do
      expect { Property.new('margin', '3px') }.to raise_error
    end

    it "should allow creation of a property via create" do
      property = Property.create('margin', '3px')
      property.should be_a(Property)
    end

    {
      'background' => BackgroundProperty,
      'background-color' => BackgroundProperty,
      'color' => Property
    }.each do |property_name, property_class|
      it "should create a #{property_class} for the #{property_name} property" do
        Property.create(property_name, '').should be_a(property_class)
      end
    end

    context "a color property" do
      let (:color) { Property.create('color', '#808080') }

      it "should respond to #to_s" do
        color.to_s.should == '#808080'
      end

      it "should respond to #inspect" do
        color.inspect.should == '#808080'
      end

      it "should respond to #to_style" do
        color.to_style.should == 'color:#808080'
      end
    end

    context "a child property" do
      it "should be able to return it's full style" do
        background = Property.create(:background, '#FFF')
        background.color.to_style.should == 'background-color:#FFF'
      end
    end
  end
end
