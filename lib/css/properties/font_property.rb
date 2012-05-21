module CSS
  class FontProperty < Property
    def name
      'font'
    end

    def to_style
      if size && family
        values = %w(style variant weight size family).map do |prop|
          if @properties[prop] != default_properties[prop]
            if prop == 'size' && get('size') != nil && @properties['line-height']
              [@properties[prop].value, @properties['line-height'].value].join('/')
            else
              @properties[prop].try(:value)
            end
          else
            nil
          end
        end.compact.join(' ')
        [name, values].join(':')
      else
        @properties.map { |property_name, property| "#{property_name == 'line-height' ? '' : 'font-'}#{property_name}:#{property.value if property}" }.join(';')
      end
    end

    private
      def init(parent, name, value)
        @parent = parent
        if name == 'line-height'
          @properties['line-height'] = Property.new(:p, 'line-height', value)
        elsif name =~ /-/
          property_name = name.sub(/[^-]+-(.*)/, '\1')
          @properties[property_name] = Property.new(self, property_name, value)
        else
          expand_property value if value
        end
      end

      def default_properties
        @@default_properties ||= {
          'style' => Property.new(self, 'style', 'normal'),
          'variant' => Property.new(self, 'variant', 'normal'),
          'weight' => Property.new(self, 'weight', 'normal'),
          'size' => Property.new(self, 'size', 'inherit'),
          'family' => Property.new(self, 'family', 'inherit'),
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
        @properties['family'] = Property.new(self, 'family', font_families.join(','))

        val = values.pop
        font_size, line_height = val.split(/\//)
        @properties['size'] = Property.new(self, 'size', font_size)
        @properties['line-height'] = Property.new(:p, 'line-height', line_height) if line_height

        val = values.shift
        if val =~ /(inherit|italic|oblique)/
          @properties['style'] = Property.new(self, 'style', val)
        else
          values << val
        end

        val = values.shift
        if val =~ /(inherit|small-caps)/
          @properties['variant'] = Property.new(self, 'variant', val)
        else
          values << val
        end

        val = values.shift
        @properties['weight'] = Property.new(self, 'weight', val) if val
      end
  end
end
