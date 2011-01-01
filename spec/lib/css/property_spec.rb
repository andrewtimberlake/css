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
  end
end
