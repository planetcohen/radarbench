module SerializableController
  #def serialize_instance(instance, options={})
  #  logger.debug "SerializableController#serialize_instance => #{instance.id}"
  #  serializer = create_instance_serializer instance, options
  #  if stale?(last_modified: instance.updated_at.utc, etag: instance_cache_key(instance, serializer, options))
  #    cache_hit = true
  #    result = Rails.cache.fetch instance_cache_key(instance, serializer, options) do
  #      log_cache_miss instance_cache_key(instance, serializer, options)
  #      cache_hit = false
  #      location ||= serializer.uri if request.post? && instance.errors.empty?
  #      #respond_with serializer, options
  #      {json: serializer.to_json, location: location}
  #    end
  #    log_cache_hit instance_cache_key(instance, serializer, options) if cache_hit
  #    options[:location] ||= result[:location]
  #    render options.merge(json: result[:json])
  #  end
  #end
  #
  #def serialize_collection(collection, options = {})
  #  logger.debug "SerializableController#serialize_collection"
  #  count = collection.count
  #  render options.merge(:json => []) and return if count == 0
  #
  #  serializer = create_collection_serializer collection, options
  #  last_modified = collection_last_modified(collection)
  #  if true #stale?(last_modified: last_modified, etag: "#{serializer.version}:#{last_modified}")
  #    cache_hit = true
  #    json = Rails.cache.fetch collection_cache_key(collection, serializer, options) do
  #      log_cache_miss collection_cache_key(collection, serializer, options)
  #      cache_hit = false
  #      #respond_with serializer, options
  #      serializer.to_json
  #    end
  #    log_cache_hit collection_cache_key(collection, serializer, options) if cache_hit
  #    render options.merge(:json => json)
  #  end
  #end

  def serialize_instance(instance, options={})
    logger.debug "SerializableController#serialize_instance => #{instance.id}"
    serializer = create_instance_serializer instance, options
    location ||= serializer.uri if request.post? && instance.errors.empty?
    render options.merge(json: serializer.to_json, location: location)
  end

  def serialize_collection(collection, options={})
    logger.debug "SerializableController#serialize_collection"
    serializer = create_collection_serializer collection, options
    render options.merge(json: serializer.to_json)
  end


  def page_of(collection)
    collection #.paginate(:page => params[:page], :per_page => 50)
  end

  def instance_serializer_class
    serializer_class
  end

  def collection_serializer_class
    serializer_class
  end
  
  def create_instance_serializer(instance, options={})
    instance_serializer_class.new(self, instance, serializer_config_from_options(options))
  end
  
  def create_collection_serializer(collection, options={})
    collection_serializer_class.new(self, page_of(collection), serializer_config_from_options(options))
  end
  
  def collection_last_modified(collection)
    @collection_last_modified ||= collection.maximum(:updated_at).try :utc
  end

  def collection_cache_key(collection, serializer, options)
    @collection_cache_key ||= begin
      config = serializer_config_from_options(options)
      max_updated_at = collection_last_modified collection
      timestamp = "#{max_updated_at.to_s(:number)}.#{max_updated_at.strftime("%L")}"
      key = "#{request.path}-#{timestamp}"
      [:include_collections, :include_item].each do |option|
        key += "/#{option}" if config[option]
      end
      "v#{serializer.version}:#{key}"
    end
  end
  
  def instance_cache_key(instance, serializer, options)
    @instance_cache_key ||= begin
      config = serializer_config_from_options(options)
      key = "#{instance.cache_key}.#{instance.updated_at.utc.strftime("%L")}"
      [:include_collections, :include_item].each do |option|
        key += "/#{option}" if config[option]
      end
      "v#{serializer.version}:#{key}"
    end
  end
  
  def serializer_config_from_options(options)
    @serializer_config ||= begin
      config = {}
      config[:include_collections] = boolean_from_param_value options.fetch(:include_collections, false)
      config[:include_item] = boolean_from_param_value options.fetch(:include_item, false)
      config[:include_user] = boolean_from_param_value options.fetch(:include_user, false)
      config[:paginate] = options.fetch(:per_page, 0).to_i > 0
      config[:per_page] = options.fetch(:per_page, 0).to_i
      config[:page_index] = options.fetch(:page_index, 1).to_i
      config
    end
  end
  
  private
  def serializer_class
    begin
      (self.class.name.split('::').last.gsub("Controller", "").singularize + "Serializer").constantize
    rescue NameError
      ResourceSerializer
    end
  end

  def log_cache_hit(key)
    log_cache "HIT", key
  end

  def log_cache_miss(key)
    log_cache "MIS", key
  end

  def log_cache(msg, key)
    logger.info "[#{Time.now.strftime '%Y-%m-%d %H:%M:%S'}] [CACHE] #{msg} :: #{key}"
  end
end
