module CSS
  class RuleSet
    def initialize
      @selectors = []
      @rules = {}
    end

    def <<(rule)
      if @selectors.include?(rule.selector)
        @rules[rule.selector] << rule
      else
        @selectors << rule.selector
        @rules[rule.selector] = rule
      end
    end

    def [](selector)
      @rules[selector]
    end

    def selectors
      @selectors
    end

    def rules
      selectors.map { |s| @rules[s] }
    end

    def to_style
      rules.map { |rule| rule.to_style }.join("\n")
    end
  end
end
