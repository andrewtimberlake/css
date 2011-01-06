require "spec_helper"

module CSS
  describe Rule do
    let(:rule) { Rule.new('#id', 'background-color:#333;color:#FFF') }

    it "should return a property by name" do
      rule.color.should == '#FFF'
    end

    it "should return a property reference with a symbol" do
      rule[:color].should == '#FFF'
    end

    it "should allow referencing a property as a method call" do
      rule.color.should == '#FFF'
    end

    it "should allow referencing a hyphenated property by camel-case method name" do
      rule.backgroundColor.should == '#333'
    end

    it "should allow referencing a hyphenated property by underscored method name" do
      rule.background_color.should == '#333'
    end

    it "should merge properties" do
      rule.background << Property.create('background-image', 'url(image.png)')

      rule.background.image.should == 'url(image.png)'
    end

    it "should respond to #to_s" do
      rule.to_s.should == "background:#333;color:#FFF"
    end

    it "should respond to #to_style" do
      rule.to_style.should == "#id{background:#333;color:#FFF}"
    end

    it "should reveal that it has a background property" do
      rule.should have_property(:background)
    end

    it "should reveal that it has a background-color property" do
      rule.should have_property(:background_color)
    end

    it "should not have a background-image property" do
      rule.should_not have_property(:background_image)
    end

    it "should not have a font property" do
      rule.should_not have_property(:font)
    end

    it "should reveal that is has one of font or background properties" do
      rule.should have_one_property(:font, :background)
    end
  end
end
