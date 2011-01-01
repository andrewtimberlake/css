module CSS
  class Property
    attr_reader :name, :value

    def initialize(*args)
      raise "Please use Property.create instead of Property.new" unless args[0] == :private
      init(args[1], args[2])
    end

    def self.create(name, value = nil)
      klass = case name
      when /^background/
        BackgroundProperty
      else
        Property
      end

      klass.new(:private, name, value)
    end

    def to_s
      @value
    end

    private
      def init(name, value)
        @name = name
        @value = value
      end
  end
end

require "css/properties/background_property.rb"
