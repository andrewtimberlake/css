module CSS
  class BorderProperty < Property
    def name
      'border'
    end

    def to_s
      value = %w(size style color).map { |prop| @properties[prop] && @properties[prop] != default_properties[prop] ? @properties[prop].value : nil }.compact.join(' ')
      if value == @properties['size'].value
        "#{@properties['size']}"
      else
        value
      end
    end

    def to_style
      value = %w(size style color).map { |prop| @properties[prop] && @properties[prop] != default_properties[prop] ? @properties[prop].value : nil }.compact.join(' ')
      if value == @properties['size'].value
        "border-size:#{@properties['size']}"
      else
        [name, value].join(':')
      end
    end

    private
      def init(name, value)
        if name =~ /-/
          property_name = name.sub(/[^-]+-(.*)/, '\1')
          @properties[property_name] = Property.new(:p, property_name, value)
        else
          expand_property value if value
        end
      end

      def default_properties
        @@default_properties ||= {
          'size' => Property.create('size', '3px'),
          'style' => nil,
          'color' => Property.create('color', 'black')
        }
      end

      def expand_property(value)
        values = value.delete(';').split(/\s+/)

        val = values.pop
        if val =~ /^(#|rgb)/ || Colors::NAMES.include?(val.upcase)
          @properties["color"] = Property.create('color', val)
        else
          values << val
        end

        val = values.pop
        if val =~ /^\d/
          values << val
        else
          @properties["style"] = Property.create('style', val) if val
        end

        val = values.pop
        @properties["size"] = Property.create('size', val) if val
      end
  end
end
