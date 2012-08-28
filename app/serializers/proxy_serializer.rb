class ProxySerializer < ResourceSerializer
  
  class << self
    alias_method :new_orig, :new

    def serializer_class_for_instance(instance)
      name = instance.class.name.split('::').last
      Kernel.const_get "#{name}Serializer"
    end

    def new(controller, resource, config={}, logger=nil)
      if resource.kind_of? Enumerable
        new_orig controller, resource, config, logger
      else
        serializer_class_for_instance(resource).new controller, resource, config, logger
      end
    end
  end

  def serializer_class_for_instance(instance)
    self.class.serializer_class_for_instance instance
  end
end
