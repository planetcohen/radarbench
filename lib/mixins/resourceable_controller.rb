module ResourceableController
  def self.included(base)
    base.send :include, ::SerializableController
    base.send :include, InstanceMethods
    base.send :before_filter, :fix_params
    base.send :before_filter, :find_instance, :only => [:show, :update, :destroy]
    base.send :before_filter, :find_collection, :only => [:index]
    base.send :respond_to, :json
  end
  
  module InstanceMethods
    def index
      serialize_collection @collection, params
    end
  
    def show
      serialize_instance @instance, params
    end
  
    def create
      @instance = build_instance
      logger.debug "@instance => #{@instance.inspect}"
      if @instance.save
        logger.debug "@instance => #{@instance.inspect}"
        serialize_instance @instance, params
      else
        logger.debug "@instance.errors => #{@instance.errors.inspect}"
        render :json => @instance.errors.to_json, :status => :unprocessable_entity
      end
    end
  
    def update
      if update_instance
        serialize_instance @instance, params
      else
        render :json => @instance.errors.to_json, :status => :unprocessable_entity
      end
    end
  
    def destroy
      delete_instance
      serialize_instance @instance, params
    end


    protected
    def fix_params
      #logger.debug "params => #{params.inspect} [#{params.class.name}]"
      if params[:callback].present? and params[:model].present?
        #logger.debug "model => #{params[:model].inspect} [#{params[:model].class.name}]"
        model = params.delete(:model)
        model = JSON.parse model  if model.instance_of? String
        params.merge! model
      end
    end

    def find_instance
      begin
        @instance = instance_resources_scope.find params[:id]
      rescue
        head :status => :not_found unless @instance
      end
    end
    
    def instance_resources_scope
      resources_scope
    end
  
    def find_collection
      logger.debug "ResourceableController#find_collection"
      @collection = collection_resources_scope
    end
    
    def collection_resources_scope
      resources_scope
    end
  
    def resources_scope
      logger.debug "ResourceableController#resources_scope"
      resources_model.scoped
    end
  
    def resources_model
      logger.debug "ResourceableController#resources_model"
      class_name = self.class.name.split('::').last.sub(/Controller$/, '').singularize
      @resources_model ||= Kernel.const_get class_name
    end
    
    def build_instance
      if build_resources_scope.respond_to? :build
        build_resources_scope.build build_resource_params
      else
        new_resources_scope.new build_resource_params
      end
    end
    
    def build_resources_scope
      resources_scope
    end
    
    def new_resources_scope
      resources_scope
    end
    
    def build_resource_params
      #params[resource_params_key]
      if params.has_key? resource_params_key
        params[resource_params_key]
      else
        params
      end
    end
    
    def update_instance
      @instance.update_attributes(update_resource_params)
    end

    def update_resource_params
      #params[resource_params_key]
      if params.has_key? resource_params_key
        params[resource_params_key]
      else
        params
      end
    end
    
    def delete_instance
      if @instance.respond_to? :soft_destroy
        @instance.soft_destroy
      else
        @instance.destroy
      end
    end

    def resource_params_key
      resource_name.to_sym
    end

    def resource_name
      resources_model.name.underscore
    end
    
    def resource_collection_url
      send "api_#{self.class.name.split('::').last.gsub(/Controller$/, '').tableize}_url"
    end

    def resource_collection_path
      send "api_#{self.class.name.split('::').last.gsub(/Controller$/, '').tableize}_path"
    end

    def resource_instance_url(options)
      send "api_#{self.class.name.split('::').last.gsub(/Controller$/, '').underscore}_url", options
    end

    def resource_instance_path(options)
      send "api_#{self.class.name.split('::').last.gsub(/Controller$/, '').underscore}_path", options
    end
    
    def render_method_not_allowed
      render nothing: true, status: :method_not_allowed
    end

  end
end
