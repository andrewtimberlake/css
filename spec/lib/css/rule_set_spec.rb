require "spec_helper"

module CSS
  describe RuleSet do
    let (:ruleset) { Parser.new.parse(fixture('style.css')) }

    it "should respond to #to_style" do
      ruleset.to_style.should match(/body\{/)
    end

    it "should return all the selectors" do
      ruleset.selectors.should be_a(Array)
    end

    it "should return all the rules" do
      ruleset.rules.should be_a(Array)
    end
  end
end
