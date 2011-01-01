module CSS
  class FontProperty < Property
    def name
      'font'
    end

    def value
      %w(style variant weight size family).map do |prop|
        if @properties[prop] != default_properties[prop]
          if prop == 'size' && @properties['line-height']
            [@properties[prop], @properties['line-height']].join('/')
          else
            @properties[prop]
          end
        else
          nil
        end
      end.compact.join(' ')
    end

    def to_s
      [name, value].join(':')
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
          'style' => 'normal',
          'variant' => 'normal',
          'weight' => 'normal',
          'size' => 'inherit',
          'family' => 'inherit',
          'line-height' => nil
        }
      end

      def expand_property(value)
        font_families = value.delete(';').split(/,/)
        values = font_families.shift.split(/\s+/)

        font_families.unshift values.pop
        if font_families[0] =~ /"\s*$/
          font_families[0] = [values.pop, font_families[0]].join(' ')
        end
        @properties['family'] = font_families.join(',')

        val = values.pop
        font_size, line_height = val.split(/\//)
        @properties['size'] = font_size
        @properties['line-height'] = line_height if line_height

        val = values.shift
        if val =~ /(inherit|italic|oblique)/
          @properties['style'] = val
        else
          values << val
        end

        val = values.shift
        if val =~ /(inherit|small-caps)/
          @properties['variant'] = val
        else
          values << val
        end

        val = values.shift
        @properties['weight'] = val if val
      end
  end
end
