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
      selectors.map { |e|  }
    end

    def to_style
      rules = []
      selectors.each do |selector|
        rules << @rules[selector].to_style
      end
      rules.join("\n")
    end
  end
end
