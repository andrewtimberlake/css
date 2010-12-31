module CSS
  class Rule
    attr_reader :selector

    def initialize(selector, rules)
      @selector = selector
      @properties, @rules = parse_rules(rules)
    end

    def [](property)
      @rules[property]
    end

    def to_s
      @properties.map { |prop| [prop, @rules[prop]].join(':') }.join ';'
    end

    private
      def parse_rules(rules)
        rules.split(/;/).inject([[], {}]) do |properties, rule|
          property = rule.split(/:/).map { |el| el.strip }
          properties[0] << property[0]
          properties[1][property[0]] = property[1]
          properties
        end
      end
  end
end
