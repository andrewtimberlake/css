module CSS
  class Property
    include Normalize

    attr_reader :name

    def initialize(*args)
      raise "Please use Property.create instead of Property.new" unless args[0] == :p
      @properties ||= {}
      init(args[1], args[2])
    end

    def self.create(name, value = nil)
      klass = case name
      when /^background/
        BackgroundProperty
      when /^(font|line-height)/
        FontProperty
      when /^border/
        BorderProperty
      when /^outline/
        OutlineProperty
      when /^margin/
        MarginProperty
      when /^padding/
        PaddingProperty
      when /^list-style/
        ListStyleProperty
      else
        Property
      end

      klass.new(:p, name, value)
    end

    def has_property?(property_name)
      @properties.keys.include?(normalize_property_name(property_name))
    end

    def to_s
      @value
    end

    def value
      to_s
    end

    def inspect
      to_s
    end

    def to_style
      [@name, @value].join(':')
    end

    def ==(val)
      if val.is_a?(Property)
        @value == val.value
      else
        @value == val
      end
    end

    def <<(val)
      @value = val
    end

    def get(property_name)
      @properties[property_name] == default_properties[property_name] ? nil : @properties[property_name]
    end

    def [](property_name)
      get property_name
    end

    def <<(merge_property)
      default_properties.keys.each do |property_name|
        @properties[property_name] = merge_property[property_name] unless merge_property[property_name] == default_properties[property_name]
      end
    end

    def method_missing(method_name, *args, &block)
      if method_name.to_s[-1..-1] == '='
        property_name = normalize_property_name(method_name.to_s.chop)
        if default_properties.keys.include?(property_name)
          @properties[property_name] = Property.new(:p, property_name, args[0])
        else
          super
        end
      else
        property_name = normalize_property_name(method_name.to_s)
        if default_properties.keys.include?(property_name)
          get(property_name)
        else
          super
        end
      end
    end

    private
      def init(name, value)
        @name = name
        @value = value
      end

      def default_properties
        {}
      end
  end
end

require "css/properties/background_property.rb"
require "css/properties/font_property.rb"
require "css/properties/border_property.rb"
require "css/properties/outline_property.rb"
require "css/properties/margin_property.rb"
require "css/properties/padding_property.rb"
require "css/properties/list_style_property.rb"
