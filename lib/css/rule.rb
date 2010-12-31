# Shorthand conversions based on guide by Dustin Diaz - http://www.dustindiaz.com/css-shorthand/
module CSS
  class Rule
    include Colors

    DEFAULT_BACKGROUND_PROPERTIES = {
      'background-color' => 'transparent',
      'background-image' => 'none',
      'background-repeat' => 'repeat',
      'background-position' => 'top left',
      'background-attachment' => 'scroll'
    }

    DEFAULT_FONT_PROPERTIES = {
      'font-style' => 'normal',
      'font-variant' => 'normal',
      'font-weight' => 'normal',
      'font-size' => 'inherit',
      'font-family' => 'inherit'
    }

    DEFAULT_BORDER_PROPERTIES = {
      'border-size' => '3px',
      'border-style' => nil,
      'border-color' => 'black'
    }

    attr_reader :selector

    def initialize(selector, rules)
      @selector = selector
      @properties, @rules = parse_rules(rules)
    end

    def get(property_name)
      if property_name.to_sym == :background
        compact_background_property
      elsif property_name.to_sym == :font
        compact_font_property
      elsif property_name.to_sym == :border
        compact_border_property
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
      if (properties & DEFAULT_BACKGROUND_PROPERTIES.keys).size > 0
        properties -= DEFAULT_BACKGROUND_PROPERTIES.keys
        properties << 'background'
      end
      if (properties & DEFAULT_FONT_PROPERTIES.keys).size > 0
        properties -= DEFAULT_FONT_PROPERTIES.keys
        properties << 'font'
      end
      if (properties & DEFAULT_BORDER_PROPERTIES.keys).size > 0
        properties -= DEFAULT_BORDER_PROPERTIES.keys
        properties << 'border'
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
        elsif name.to_s =~ /_/
          name.to_s.gsub(/_/, '-')
        else
          name.to_s
        end
      end

      def expand_property(name, value)
        if name == 'background'
          expand_background_property value
        elsif name == 'font'
          expand_font_property value
        elsif name == 'border'
          expand_border_property value
        else
          {name => value}
        end
      end

      def expand_background_property(value)
        properties = DEFAULT_BACKGROUND_PROPERTIES.clone
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

      def expand_font_property(value)
        properties = DEFAULT_FONT_PROPERTIES.clone
        font_families = value.split(/,/)
        values = font_families.shift.split(/\s+/)

        font_families.unshift values.pop
        properties['font-family'] = font_families.join(',')

        val = values.pop
        font_size, line_height = val.split(/\//)
        properties['font-size'] = font_size
        properties['line-height'] = line_height if line_height

        val = values.shift
        if val =~ /(inherit|italic|oblique)/
          properties['font-style'] = val
        else
          values << val
        end

        val = values.shift
        if val =~ /(inherit|small-caps)/
          properties['font-variant'] = val
        else
          values << val
        end

        val = values.shift
        properties['font-weight'] = val if val

        properties
      end

      def expand_border_property(value)
        properties = DEFAULT_BORDER_PROPERTIES.clone

        values = value.split(/\s+/)

        val = values.pop
        if val =~ /^(#|rgb)/ || Colors::NAMES.include?(val.upcase)
          properties['border-color'] = val
        else
          values << val
        end

        val = values.pop
        properties['border-style'] = val if val

        val = values.pop
        properties['border-size'] = val if val

        properties
      end

      def compact_background_property
        %w(background-color background-image background-repeat background-position background-attachment).map { |prop| @rules[prop] != DEFAULT_BACKGROUND_PROPERTIES[prop] ? @rules[prop] : nil }.compact.join(' ')
      end

      def compact_font_property
        %w(font-style font-variant font-weight font-size font-family).map do |prop|
          if @rules[prop] != DEFAULT_FONT_PROPERTIES[prop]
            if prop == 'font-size' && @rules['line-height']
              [@rules[prop], @rules['line-height']].join('/')
            else
              @rules[prop]
            end
          else
            nil
          end
        end.compact.join(' ')
      end

      def compact_border_property
        %w(border-size border-style border-color).map { |prop| @rules[prop] != DEFAULT_BORDER_PROPERTIES[prop] ? @rules[prop] : nil }.compact.join(' ')
      end
  end
end
