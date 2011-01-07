require 'css/helpers/orientation'

module CSS
  class MarginProperty < Property
    include Orientation

    def name
      'margin'
    end

    def to_s
      top = @properties['top']
      right = @properties['right']
      bottom = @properties['bottom']
      left = @properties['left']

      compact_orientation(top, right, bottom, left)
    end

    def ==(val)
      if val.is_a?(Property)
        super
      else
        to_s == val
      end
    end

    def to_style
      top = @properties['top']
      right = @properties['right']
      bottom = @properties['bottom']
      left = @properties['left']

      if top && right && bottom && left
        value = to_s
        [name, value].join(':')
      else
        default_properties.keys.map { |prop| @properties[prop] ? ["#{name}-#{prop}", @properties[prop]].join(':') : nil }.compact.join(';')
      end
    end

    private
      def init(parent, name, value)
        @parent = parent
        if name =~ /-/
          property_name = name.sub(/[^-]+-(.*)/, '\1')
          @properties[property_name] = Property.new(self, property_name, value)
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

        @properties['top'] = Property.new(self, 'top', top)
        @properties['right'] = Property.new(self, 'right', right)
        @properties['bottom'] = Property.new(self, 'bottom', bottom)
        @properties['left'] = Property.new(self, 'left', left)
      end
  end
end
