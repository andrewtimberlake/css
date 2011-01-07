unless Object.methods.include?('try')
  class Object
    def try(method_name, *args)
      send(method_name, *args) if respond_to?(method_name, true)
    end
  end
end

unless NilClass.methods.include?('empty?')
  class NilClass
    def empty?
      true
    end
  end
end
