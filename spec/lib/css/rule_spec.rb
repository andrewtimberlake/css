require "spec_helper"

module CSS
  describe Rule do
    let(:rule) { Rule.new('#id', 'background-color:#333;color:#FFF;z-index:99') }

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
      rule.to_s.should == "background:#333;color:#FFF;z-index:99"
    end

    it "should respond to #dup" do
      duplicate = rule.dup
      duplicate.to_style.should == rule.to_style
    end

    it "should respond to #to_style" do
      rule.to_style.should == "#id{background:#333;color:#FFF;z-index:99}"
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

    it "should not have a border-color property" do
      rule.should_not have_property(:border_color)
    end

    it "should reveal that is has one of font or background properties" do
      rule.should have_one_property(:font, :background)
    end

    it "should be able to retrieve a long-hand rule via []" do
      rule['background-color'].should == '#333'
    end

    it "should be able to retrieve a property with a hyphen" do
      rule['z-index'].should == '99'
    end

    it "should be able to set a property value with []=" do
      rule['z-index'] = '100'
      rule['z-index'].should == '100'
    end

    it "should be able to set a property by method call" do
      rule.z_index = '100'
      rule.z_index.should == '100'
    end

    it "should be able to set a short-hand property" do
      rule['background'] = 'url(image2.png)'
      rule.background.image.should == 'url(image2.png)'
    end

    it "should be able to set a short-hand property via method call" do
      rule.background = 'url(image2.png)'
      rule.background.image.should == 'url(image2.png)'
    end

    it "should be able to set a long-hand property" do
      rule['background-image'] = 'url(image2.png)'
      rule.background.image.should be_a(Property)
      rule.background.image.should == 'url(image2.png)'
    end

    it "should be able to set a long-hand property via method call" do
      rule.background.image = 'url(image2.png)'
      rule.background.image.should be_a(Property)
      rule.background.image.should == 'url(image2.png)'
    end
  end
end
