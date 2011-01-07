require 'css/helpers/normalize'

module CSS
  class Property
    include Normalize

    def initialize(*args)
      raise "Please use Property.create instead of Property.new" unless args[0] == :p || args[0].is_a?(Property)
      @properties = {}
      name = args[1]
      value = clean_value(args[2])
      init(args[0].is_a?(Property) ? args[0] : nil, name, value)
    end

    def self.create(name, value = nil)
      klass = case name.to_s
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

    def name
      [@parent.try(:name), @name].compact.join('-')
    end

    def to_s
      to_style
    end

    def value
      @value
    end

    def inspect
      "#<Property #{to_style}>"
    end

    def to_style
      [name, @value].join(':')
    end

    def ==(val)
      if val.is_a?(Property)
        @value == val.instance_variable_get(:@value) && @properties == val.instance_variable_get(:@properties)
      else
        @value == val
      end
    end

    def eql?(property)
      property.is_a?(Property) && self == property
    end

    def hash
      to_style.hash
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

    def respond_to?(method_name, include_private = false)
      property_name = normalize_property_name(method_name.to_s[-1..-1] == '=' ? method_name.to_s.chop : method_name)
      default_properties.keys.include?(property_name) || super
    end

    def empty?
      @value.nil? && @properties.all? { |p| p.empty? }
    end

    private
      def init(parent, name, value)
        @parent = parent
        @name = name
        @value = value
      end

      def default_properties
        {}
      end

      def clean_value(value)
        return if value.nil?

        value = value.
                  to_s.
                  strip.
                  gsub(/rgba?\([^)]+\)/) { |match| match.delete(' ') }
      end
  end
end

require "css/properties/margin_property.rb"
require "css/properties/background_property.rb"
require "css/properties/font_property.rb"
require "css/properties/border_property.rb"
require "css/properties/border_orientation_property.rb"
require "css/properties/border_unit_property.rb"
require "css/properties/outline_property.rb"
require "css/properties/padding_property.rb"
require "css/properties/list_style_property.rb"
