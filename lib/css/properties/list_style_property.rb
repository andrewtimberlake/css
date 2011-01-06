module CSS
  class ListStyleProperty < Property
    def initialize(*args)
      @properties = default_properties.clone
      super
    end

    def name
      'list-style'
    end

    def to_s
      %w(type position image).map { |prop| @properties[prop] }.join(' ')
    end

    def to_style
      [name, to_s].join(':')
    end

    def type
      default_properties['type'] == @properties['type'] ? nil : @properties['type']
    end

    def type=(val)
      @properties['type'] = val
    end

    private
      def init(parent, name, value)
        @parent = parent
        expand_property value if value
      end

      def default_properties
        @@default_properties ||= {
          'type' => Property.new(self, 'type', 'disc'),
          'position' => Property.new(self, 'position', 'outside'),
          'image' => Property.new(self, 'image', 'none')
        }
      end

      def expand_property(value)
        values = value.delete(';').split(/\s+/)
        while values.size > 0
          val = values.shift
          if val =~ /^url/
            @properties['image'] = Property.new(self, 'image', val)
          elsif val =~ /^(inside|outside)/
            @properties['position'] = Property.new(self, 'position', val)
          else
            @properties['type'] = Property.new(self, 'type', val)
          end
        end
      end
  end
end
