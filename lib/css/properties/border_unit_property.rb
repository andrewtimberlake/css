module CSS
  class BorderUnitProperty < MarginProperty
    def init(parent, name, value)
      @name = name
      super
    end

    def name
      @name
    end

    def to_style
      [@parent.try(:name), super].compact.join('-')
    end
  end
end
