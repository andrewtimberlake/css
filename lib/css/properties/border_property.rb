module CSS
  class BorderProperty < Property
    def name
      'border'
    end

    def to_s
      value = %w(size style color).map { |prop| @properties[prop] != default_properties[prop] ? @properties[prop] : nil }.compact.join(' ')
      if value == @properties['size']
        "border-size:#{@properties['size']}"
      else
        [name, value].join(':')
      end
    end

    private
      def init(name, value)
        if name =~ /-/
          @properties[name.sub(/[^-]+-(.*)/, '\1')] = value
        else
          expand_property value if value
        end
      end

      def default_properties
        {
          'size' => '3px',
          'style' => nil,
          'color' => 'black'
        }
      end

      def expand_property(value)
        values = value.delete(';').split(/\s+/)

        val = values.pop
        if val =~ /^(#|rgb)/ || Colors::NAMES.include?(val.upcase)
          @properties["color"] = val
        else
          values << val
        end

        val = values.pop
        if val =~ /^\d/
          values << val
        else
          @properties["style"] = val if val
        end

        val = values.pop
        @properties["size"] = val if val
      end
  end
end
