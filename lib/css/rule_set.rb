module CSS
  class RuleSet
    def initialize
      @selectors = []
      @rulesets = {}
    end

    def <<(rule)
      @selectors << rule.selector
      @rulesets[rule.selector] = rule
    end

    def [](selector)
      @rulesets[selector]
    end

    def selectors
      @selectors
    end
  end
end
