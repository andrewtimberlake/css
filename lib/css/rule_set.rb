module CSS
  class RuleSet
    def initialize
      @selectors = []
      @rulesets = {}
    end

    def <<(rule)
      if @selectors.include?(rule.selector)
        @rulesets[rule.selector] << rule
      else
        @selectors << rule.selector
        @rulesets[rule.selector] = rule
      end
    end

    def [](selector)
      @rulesets[selector]
    end

    def selectors
      @selectors
    end
  end
end
