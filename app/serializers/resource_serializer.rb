class ResourceSerializer
  include Rails.application.routes.url_helpers

  attr_reader :controller, :resource, :config, :logger

  delegate :params, :to => :controller
  delegate :default_url_options, :to => :controller
  delegate :current_user, :to => :controller
  delegate :errors, :to => :resource

  def initialize(controller, resource, config={}, logger=nil)
    Rails.logger.debug "ResourceSerializer#initialize"
    @logger = logger || Rails.logger
    @controller = controller
    @resource = resource
    @config = config
  end
  
  def as_json(options = {})
    if collection?
      collection_as_json options
    else
      instance_as_json options
    end
  end
  
  def version
    1
  end
  
  def collection_as_json(options = {})
    paginate_collection(resource).map {|instance| serializer_class_for_instance(instance).new(controller, instance, config).as_json options}
  end
  
  def serializer_class_for_instance(instance)
    self.class
  end

  def instance_as_json(options = {})
    resource.to_json
  end

  def uri
    return '' if controller.nil?
    suffix = if controller.default_url_options.has_key? :host then 'url' else 'path' end
    if collection?
      collection_uri suffix
    else
      instance_uri suffix
    end
  end
  
  def collection_uri(suffix)
    method = if controller.respond_to? :"resource_collection_#{suffix}"
      :"resource_collection_#{suffix}"
    else
      "#{controller.class.name.gsub(/Controller$/, '').tableize}_#{suffix}"
    end
    controller.send method
  end
  
  def instance_uri(suffix)
    method = if controller.respond_to? :"resource_instance_#{suffix}"
      :"resource_instance_#{suffix}"
    else
      "#{controller.class.name.gsub(/Controller$/, '').underscore}_#{suffix}"
    end
    controller.send method, :id => resource.to_param
  end
  
  def collection?
    resource.kind_of? Enumerable or resource.instance_of? ActiveRecord::Relation
  end
  
  def paginate_collection(collection)
    return collection unless config[:paginate]

    Rails.logger.debug "paginate: paginate => #{config[:paginate]}, per_page => #{config[:per_page]}, page => #{config[:page_index]}"
    per_page = config[:per_page]
    offset   = (config[:page_index] - 1)*per_page
    Rails.logger.debug "paginate: per_page => #{per_page}, offset => #{offset}"
    collection.limit(per_page).offset(offset)
  end
  
end
