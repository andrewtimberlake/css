# Shorthand conversions based on guide by Dustin Diaz - http://www.dustindiaz.com/css-shorthand/
require 'set'
require 'css/helpers/normalize'

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
      property_name = normalize_property_name(property_name)
      if property_name =~ /-/
        property_name_parts = property_name.split('-')
        pname = property_name_parts.shift
        property = nil
        while property_name_parts.size > 0
          property = @rules[normalize_property_name(pname)]
          break unless property.nil?
          pname = [pname, property_name_parts.shift].join('-')
        end
        property = @rules[normalize_property_name(pname)] unless property
        if property && property_name_parts.size == 0
          property
        else
          property ? property[property_name_parts.shift] : nil
        end
      else
        @rules[normalize_property_name(property_name)]
      end
    end

    def [](property_name)
      get property_name
    end

    def []=(property_name, value)
      property = get(property_name)
      unless property
        property = Property.create(property_name, value)
        if @rules[property.name]
          @rules[property.name] << property
        else
          @properties << property.name
          @rules[property.name] = property
        end
      end
      property.value = value
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
      !get(property_name).empty?
    end

    def method_missing(method_name, *args)
      if method_name.to_s[-1..-1] == '='
        property_name = method_name.to_s.chop
        self[property_name] = args[0]
      else
        get(method_name) || super
      end
    end

    private
      def parse_rules(properties, rules, rule_text)
        rule_text.split(/;/).inject([properties, rules]) do |properties, rule|
          property = rule.split(/:/)
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
