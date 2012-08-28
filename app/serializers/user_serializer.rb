class UserSerializer < ResourceSerializer
  def instance_as_json(options={})
    logger.debug "resource => #{resource.inspect}"
    result = {
      version:  version,
      
      id:  resource.to_param,
      
      email: resource.email,
      first_name: resource.first_name,
      last_name: resource.last_name,
      full_name: resource.full_name,
      
      created_at:  resource.created_at,
      updated_at:  resource.updated_at
    }

    result
  end

end
