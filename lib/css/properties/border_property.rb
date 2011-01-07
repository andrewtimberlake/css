require 'css/helpers/orientation'

module CSS
  class BorderProperty < Property
    include Orientation

    def name
      'border'
    end

    def style_values
      NESW.map { |o| send(o).style }
    end

    def size_values
      NESW.map { |o| send(o).size }
    end

    def color_values
      NESW.map { |o| send(o).color }
    end

    def to_s
      if %w(size style color).map { |p| send("#{p}_values").uniq }.flatten.compact.size == 3
        %w(size style color).map { |p| top.send(p) }.join(' ')
      elsif %w(style color).map { |p| send("#{p}_values").uniq }.flatten.compact.size == 0
        ["#{name}-size", top.size].join(':')
      elsif %w(style color).map { |p| send("#{p}_values").uniq }.flatten.compact.size == 2
        %w(style color).map { |p| top.send(p) }.flatten.compact.join(' ')
      elsif %w(size style).map { |p| send("#{p}_values").uniq }.flatten.compact.size == 2
        %w(size style).map { |p| top.send(p) }.flatten.compact.join(' ')
      end
    end

    def to_style
      if %w(size style color).map { |p| send("#{p}_values").uniq }.flatten.compact.size == 3
        value = %w(size style color).map { |p| top.send(p) }.compact.join(' ')
        [name, value].join(':')
      elsif %w(style color).map { |p| send("#{p}_values").uniq }.flatten.compact.size == 0
        ["#{name}-size", top.size].join(':')
      elsif %w(style color).map { |p| send("#{p}_values").uniq }.flatten.compact.size == 2
        value = %w(style color).map { |p| top.send(p) }.flatten.compact.join(' ')
        [name, value].join(':')
      elsif %w(size style).map { |p| send("#{p}_values").uniq }.flatten.compact.size == 2
        value = %w(size style).map { |p| top.send(p) }.flatten.compact.join(' ')
        [name, value].join(':')
      else
        NESW.map { |o| send(o).to_style }.join(';')
      end
    end

    def size
      method_missing(:size)
    end

    def method_missing(method_name, *args)
      if method_name.to_s[-1..-1] == '='
        property_name = normalize_property_name(method_name.to_s.chop)
        if %w(size style color).include?(property_name)
          NESW.each do |o|
            @properties[o].send(method_name, *args)
          end
        else
          super
        end
      else
        if %w(color size style).include?(method_name.to_s)
          property = BorderUnitProperty.new(self, method_name.to_s)
          is_nil = true
          NESW.each do |o|
            prop = @properties[o].send(method_name).try(:value)
            if prop
              property.send("#{o}=", prop)
              is_nil = false
            end
          end
          is_nil ? nil :property
        else
          super
        end
      end
    end

    private
      def init(parent, name, value)
        @parent = parent

        #Allocate new orientation properties
        NESW.each do |o|
          @properties[o] = BorderOrientationProperty.new(self, o)
        end

        if name =~ /-/
          property_name = name.sub(/[^-]+-(.*)/, '\1')
          if NESW.include?(property_name)
            @properties[property_name] = BorderOrientationProperty.new(self, property_name, value)
          else
            NESW.each do |orientation|
              @properties[orientation].send("#{property_name}=", value)
            end
          end
        else
          expand_property value if value
        end
      end

      def default_properties
        @@default_properties ||= {
          'top' => BorderOrientationProperty.new(self, 'top'),
          'right' => BorderOrientationProperty.new(self, 'right'),
          'bottom' => BorderOrientationProperty.new(self, 'bottom'),
          'left' => BorderOrientationProperty.new(self, 'left')
        }
      end

      def expand_property(value)
        values = value.delete(';').split(/\s+/)

        val = values.pop
        if val =~ /^(#|rgb)/ || Colors::NAMES.include?(val.upcase)
          NESW.each do |o|
            @properties[o].send('color=', val)
          end
        else
          values << val
        end

        val = values.pop
        if val =~ /^\d/
          values << val
        else
          if val
            NESW.each do |o|
              @properties[o].send('style=', val)
            end
          end
        end

        val = values.pop
        if val
          NESW.each do |o|
            @properties[o].send('size=', val)
          end
        end
      end
  end
end
