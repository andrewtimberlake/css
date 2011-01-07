module CSS
  class BorderOrientationProperty < Property
    def to_s
      value = %w(size style color).map { |prop| @properties[prop] && @properties[prop] != default_properties[prop] ? @properties[prop].value : nil }.compact.join(' ')
      if @properties['size'] && value == @properties['size'].value
        "#{@properties['size']}"
      else
        value
      end
    end

    def to_style
      value = %w(size style color).map { |prop| @properties[prop] && @properties[prop] != default_properties[prop] ? @properties[prop].value : nil }.compact.join(' ')
      if @properties['color'].nil? && @properties['style'].nil?
        "border-size:#{@properties['size']}"
      else
        [name, value].join(':')
      end
    end

    private
      def init(parent, name, value)
        @parent = parent
        @name = name
        if name =~ /-/
          property_name = name.sub(/[^-]+-(.*)/, '\1')
          @properties[property_name] = Property.new(self, property_name, value)
        else
          expand_property value if value
        end
      end

      def default_properties
        @@default_properties ||= {
          'size' => Property.new(self, 'size', '3px'),
          'style' => nil,
          'color' => Property.new(self, 'color', 'black')
        }
      end

      def expand_property(value)
        values = value.delete(';').split(/\s+/)

        val = values.pop
        if val =~ /^(#|rgb)/ || Colors::NAMES.include?(val.upcase)
          @properties["color"] = Property.new(self, 'color', val)
        else
          values << val
        end

        val = values.pop
        if val =~ /^\d/
          values << val
        else
          @properties["style"] = Property.new(self, 'style', val) if val
        end

        val = values.pop
        @properties["size"] = Property.new(self, 'size', val) if val
      end
  end
end
