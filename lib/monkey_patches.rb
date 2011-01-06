unless Object.methods.include?('try')
  class Object
    def try(method_name, *args)
      send(method_name, *args) if respond_to?(method_name, true)
    end
  end
end
