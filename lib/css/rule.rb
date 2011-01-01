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

    DEFAULT_MARGIN_PROPERTIES = {
      'margin-top' => nil,
      'margin-right' => nil,
      'margin-bottom' => nil,
      'margin-left' => nil
    }

    DEFAULT_LIST_STYLE_PROPERTIES = {
      'list-style-type' => 'disc',
      'list-style-position' => 'outside',
      'list-style-image' => 'none'
    }

    attr_reader :selector

    def initialize(selector, rule_text)
      @selector = selector
      @properties = Set.new
      @rules = {}

      parse_rules(@properties, @rules, rule_text)
    end

    def <<(rule)
      rule.properties.each do |property|
        @properties << property
        @rules[property] = rule[property]
      end
    end

    def get(property_name)
      if property_name == 'background'
        compact_background_property
      elsif property_name == 'font'
        compact_font_property
      elsif %w(border outline border-left border-right border-top border-bottom).include?(property_name)
        compact_border_property(property_name)
      elsif %w(margin padding).include?(property_name)
        compact_margin_property(property_name)
      elsif property_name == 'list-style'
        compact_list_style_property
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

    def properties
      @properties
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
      %w(border outline border-left border-right border-top border-bottom).each do |prop|
        default_properties = DEFAULT_BORDER_PROPERTIES.keys.map { |p| p.sub(/^border/, prop) }
        if (properties & default_properties).size > 0
          properties -= default_properties
          properties << prop
        end
      end
      %w(margin padding).each do |prop|
        default_properties = DEFAULT_MARGIN_PROPERTIES.keys.map { |p| p.sub(/^margin/, prop) }
        if (properties & default_properties).size > 0
          properties -= default_properties
          properties << prop
        end
      end
      if (properties & DEFAULT_LIST_STYLE_PROPERTIES.keys).size > 0
        properties -= DEFAULT_LIST_STYLE_PROPERTIES.keys
        properties << 'list-style'
      end
      properties
    end

    def method_missing(method_name, *args)
      property_name = normalize_property_name(method_name)
      get(property_name) || super
    end

    private
      def parse_rules(properties, rules, rule_text)
        rule_text.split(/;/).inject([properties, rules]) do |properties, rule|
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
        elsif %w(border outline border-left border-right border-top border-bottom).include?(name)
          expand_border_property name, value
        elsif %w(margin padding).include?(name)
          expand_margin_property name, value
        elsif name == 'list-style'
          expand_list_style_property value
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

      def expand_border_property(prefix, value)
        properties = DEFAULT_BORDER_PROPERTIES.inject({}) { |hash, prop| hash[prop[0].sub(/^border/, prefix)] = prop[1]; hash }

        values = value.split(/\s+/)

        val = values.pop
        if val =~ /^(#|rgb)/ || Colors::NAMES.include?(val.upcase)
          properties["#{prefix}-color"] = val
        else
          values << val
        end

        val = values.pop
        properties["#{prefix}-style"] = val if val

        val = values.pop
        properties["#{prefix}-size"] = val if val

        properties
      end

      def expand_margin_property(prefix, value)
        properties = DEFAULT_MARGIN_PROPERTIES.inject({}) { |hash, prop| hash[prop[0].sub(/^margin/, prefix)] = prop[1]; hash }

        values = value.split(/\s+/)

        top, right, bottom, left = 0, 0, 0, 0
        if values.size == 1
          top = values[0]
          right = values[0]
          bottom = values[0]
          left = values[0]
        elsif values.size == 2
          top = values[0]
          bottom = values[0]
          left = values[1]
          right = values[1]
        elsif values.size == 3
          top = values[0]
          bottom = values[2]
          left = values[1]
          right = values[1]
        else
          top = values[0]
          right = values[1]
          bottom = values[2]
          left = values[3]
        end

        properties["#{prefix}-top"] = top
        properties["#{prefix}-right"] = right
        properties["#{prefix}-bottom"] = bottom
        properties["#{prefix}-left"] = left

        properties
      end

      def expand_list_style_property(value)
        properties = DEFAULT_LIST_STYLE_PROPERTIES.clone
        values = value.split(/\s+/)
        while values.size > 0
          val = values.shift
          if val =~ /^url/
            properties['list-style-image'] = val
          elsif val =~ /^(inside|outside)/
            properties['list-style-position'] = val
          else
            properties['list-style-type'] = val
          end
        end
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

      def compact_border_property(prefix)
        %w(size style color).map { |p| "#{prefix}-#{p}" }.map { |prop| @rules[prop] != DEFAULT_BORDER_PROPERTIES[prop] ? @rules[prop] : nil }.compact.join(' ')
      end

      def compact_margin_property(prefix)
        top = @rules["#{prefix}-top"]
        right = @rules["#{prefix}-right"]
        bottom = @rules["#{prefix}-bottom"]
        left = @rules["#{prefix}-left"]

        if top && right && bottom && left
          if [top, right, bottom, left] == Array.new(4) { top }
            top
          elsif [top, bottom] == Array.new(2) { top } && [left, right] == Array.new(2) { left }
            [top, left].join(' ')
          elsif [top, bottom] != Array.new(2) { top } && [left, right] == Array.new(2) { left }
            [top, left, bottom].join(' ')
          else
            [top, right, bottom, left].join(' ')
          end
        end
      end

      def compact_list_style_property
        %w(list-style-type list-style-position list-style-image).map { |prop| @rules[prop] != DEFAULT_BACKGROUND_PROPERTIES[prop] ? @rules[prop] : nil }.compact.join(' ')
      end
  end
end
