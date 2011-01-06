module CSS
  class BackgroundProperty < Property
    def name
      'background'
    end

    def to_s
      %w(color image repeat position attachment).map { |prop| @properties[prop] && @properties[prop] != default_properties[prop] ? @properties[prop].value : nil }.compact.join(' ')
    end

    def to_style
      [name, to_s].join(':')
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
          'color' => Property.create('color', 'transparent'),
          'image' => Property.create('image', 'none'),
          'repeat' => Property.create('repeat', 'repeat'),
          'position' => Property.create('position', 'top left'),
          'attachment' => Property.create('attachment', 'scroll')
        }
      end

      def expand_property(value)
        values = value.delete(';').split(/\s+/)
        while values.size > 0
          val = values.shift
          if val =~ /^(#|rgb)/ || val == 'transparent' || Colors::NAMES.keys.include?(val.to_s.upcase)
            @properties['color'] = Property.create('color', val)
          elsif val =~ /^url/
            @properties['image'] = Property.create('image', val)
          elsif val =~ /repeat/
            @properties['repeat'] = Property.create('repeat', val)
          elsif val =~ /^(\d|top|bottom|center)/
            val2 = values.shift
            @properties['position'] = Property.create('position', [val, val2].join(' '))
          elsif val =~ /inherit/
            if values.size == 0
              @properties['attachment'] = Property.create('attachment', val)
            else
              @properties['repeat'] = Property.create('repeat', val)
            end
          elsif values.size == 0
            @properties['attachment'] = Property.create('attachment', val)
          end
        end
      end
  end
end
