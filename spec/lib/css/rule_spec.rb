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
  end
end
