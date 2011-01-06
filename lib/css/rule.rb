# Shorthand conversions based on guide by Dustin Diaz - http://www.dustindiaz.com/css-shorthand/
require 'set'

module CSS
  class Rule
    include Colors
    include Normalize

    attr_reader :selector, :properties

    def initialize(selector, rule_text)
      @selector = selector
      @properties = ::Set.new
      @rules = {}

      parse_rules(@properties, @rules, rule_text)
    end

    def <<(rule)
      rule.properties.each do |property|
        if @rules[property]
          @rules[property] << rule[property]
        else
          @properties << property
          @rules[property] = rule[property]
        end
      end
    end

    def get(property_name)
      @rules[normalize_property_name(property_name)]
    end

    def [](property_name)
      get property_name
    end

    def to_s
      properties.map { |prop| get(prop).to_style }.join ';'
    end

    def to_style
      "#{selector}{#{to_s}}"
    end

    def has_one_property?(*property_names)
      property_names.any?{ |property_name| has_property?(property_name) }
    end

    def has_property?(property_name)
      property_name = normalize_property_name(property_name)
      if property_name =~ /-/
        property_name_parts = property_name.split('-')
        pname = property_name_parts.shift
        property = nil
        while property_name_parts.size > 0
          property = get(pname)
          break unless property.nil?
          pname = [pname, property_name_parts.shift].join('-')
        end
        property ? property.has_property?(property_name_parts.shift) : false
      else
        properties.include?(property_name)
      end
    end

    def method_missing(method_name, *args)
      property_name = normalize_property_name(method_name)
      if property_name =~ /-/
        property_name_parts = property_name.split('-')
        pname = property_name_parts.shift
        property = nil
        while property_name_parts.size > 0
          property = get(pname)
          break unless property.nil?
          pname = [pname, property_name_parts.shift].join('-')
        end
        property[property_name_parts.shift]
      else
        get(property_name) || super
      end
    end

    private
      def parse_rules(properties, rules, rule_text)
        rule_text.split(/;/).inject([properties, rules]) do |properties, rule|
          property = rule.split(/:/).map { |el| el.strip }
          name = normalize_property_name(property[0])
          value = property[1]

          property = Property.create(name, value)
          properties[0] << property.name
          properties[1][property.name] = property

          properties
        end
      end
  end
end
