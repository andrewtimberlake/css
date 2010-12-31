# Shorthand conversions based on guide by Dustin Diaz - http://www.dustindiaz.com/css-shorthand/
module CSS
  class Rule
    include Colors

    DEFAULT_BACKGROUND_RULES = {
      'background-color' => 'transparent',
      'background-image' => 'none',
      'background-repeat' => 'repeat',
      'background-position' => 'top left',
      'background-attachment' => 'scroll'
    }

    attr_reader :selector

    def initialize(selector, rules)
      @selector = selector
      @properties, @rules = parse_rules(rules)
    end

    def get(property_name)
      if [:background].include?(property_name.to_sym)
        compact_background_property
      else
        @rules[normalize_property_name(property_name)]
      end
    end

    def [](property_name)
      get property_name
    end

    def to_s
      normalized_properties.map { |prop| [prop, get(prop)].join(':') }.join ';'
    end

    def normalized_properties
      properties = @properties.clone
      if properties & DEFAULT_BACKGROUND_RULES.keys
        properties -= DEFAULT_BACKGROUND_RULES.keys
        properties << 'background'
      end
      properties
    end

    def method_missing(method_name, *args)
      property_name = normalize_property_name(method_name)
      get(property_name) || super
    end

    private
      def parse_rules(rules)
        rules.split(/;/).inject([[], {}]) do |properties, rule|
          property = rule.split(/:/).map { |el| el.strip }
          name = normalize_property_name(property[0])
          value = property[1]
          expand_property(name, value).each do |key, val|
            properties[0] << key
            properties[1][key] = val
          end
          properties
        end
      end

      def normalize_property_name(name)
        if name.to_s =~ /[A-Z]/
          name.to_s.gsub(/([A-Z])/) do |match|
            "-#{match.downcase}"
          end
        else
          name.to_s
        end
      end

      def expand_property(name, value)
        if name == 'background'
          expand_background_property value
        else
          {name => value}
        end
      end

      def expand_background_property(value)
        properties = DEFAULT_BACKGROUND_RULES.clone
        values = value.split(/\s+/)
        while values.size > 0
          val = values.shift
          if val =~ /^(#|rgb)/ || val == 'transparent' || Colors::NAMES.keys.include?(val.to_s.upcase)
            properties['background-color'] = val
          elsif val =~ /^url/
            properties['background-image'] = val
          elsif val =~ /repeat/
            properties['background-repeat'] = val
          elsif val =~ /^(\d|top|bottom|center)/
            val2 = values.shift
            properties['background-position'] = [val, val2].join(' ')
          elsif val =~ /inherit/
            if values.size == 0
              properties['background-attachment'] = val
            else
              properties['background-repeat'] = val
            end
          elsif values.size == 0
            properties['background-attachment'] = val
          end
        end
        properties
      end

      def compact_background_property
        %w(background-color background-image background-repeat background-position background-attachment).map { |prop| @rules[prop] != DEFAULT_BACKGROUND_RULES[prop] ? @rules[prop] : nil }.compact.join(' ')
      end
  end
end
