module CSS
  class MarginProperty < Property
    def name
      'margin'
    end

    def to_s
      top = @properties['top']
      right = @properties['right']
      bottom = @properties['bottom']
      left = @properties['left']

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

    def to_style
      top = @properties['top']
      right = @properties['right']
      bottom = @properties['bottom']
      left = @properties['left']

      if top && right && bottom && left
        value = if [top, right, bottom, left] == Array.new(4) { top }
          top
        elsif [top, bottom] == Array.new(2) { top } && [left, right] == Array.new(2) { left }
          [top, left].join(' ')
        elsif [top, bottom] != Array.new(2) { top } && [left, right] == Array.new(2) { left }
          [top, left, bottom].join(' ')
        else
          [top, right, bottom, left].join(' ')
        end
        [name, value].join(':')
      else
        default_properties.keys.map { |prop| @properties[prop] ? ["#{name}-#{prop}", @properties[prop]].join(':') : nil }.compact.join(';')
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
          'top' => nil,
          'right' => nil,
          'bottom' => nil,
          'left' => nil
        }
      end

      def expand_property(value)
        values = value.delete(';').split(/\s+/)

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

        @properties['top'] = Property.new(:p, 'top', top)
        @properties['right'] = Property.new(:p, 'right', right)
        @properties['bottom'] = Property.new(:p, 'bottom', bottom)
        @properties['left'] = Property.new(:p, 'left', left)
      end
  end
end
