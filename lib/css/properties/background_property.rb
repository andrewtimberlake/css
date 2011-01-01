module CSS
  class BackgroundProperty < Property
    DEFAULT_PROPERTIES = {
      'color' => 'transparent',
      'image' => 'none',
      'repeat' => 'repeat',
      'position' => 'top left',
      'attachment' => 'scroll'
    }

    def initialize(*args)
      @properties = DEFAULT_PROPERTIES.clone
      super
    end

    def name
      'background'
    end

    def value
      %w(color image repeat position attachment).map { |prop| @properties[prop] != DEFAULT_PROPERTIES[prop] ? @properties[prop] : nil }.compact.join(' ')
    end

    def to_s
      [name, value].join(':')
    end

    def method_missing(method_name, *args, &block)
      if method_name.to_s[-1..-1] == '='
        @properties[method_name.to_s.chop] = args[0]
      else
        @properties[method_name.to_s] || super
      end
    end

    private
      def init(name, value)
        if name =~ /-/
          @properties[name.sub(/[^-]+-(.*)/, '$1')] = value
        else
          expand_property value if value
        end
      end

      def expand_property(value)
        values = value.delete(';').split(/\s+/)
        while values.size > 0
          val = values.shift
          if val =~ /^(#|rgb)/ || val == 'transparent' || Colors::NAMES.keys.include?(val.to_s.upcase)
            @properties['color'] = val
          elsif val =~ /^url/
            @properties['image'] = val
          elsif val =~ /repeat/
            @properties['repeat'] = val
          elsif val =~ /^(\d|top|bottom|center)/
            val2 = values.shift
            @properties['position'] = [val, val2].join(' ')
          elsif val =~ /inherit/
            if values.size == 0
              @properties['attachment'] = val
            else
              @properties['repeat'] = val
            end
          elsif values.size == 0
            @properties['attachment'] = val
          end
        end
      end
  end
end
