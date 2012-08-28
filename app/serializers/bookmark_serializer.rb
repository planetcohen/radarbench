class BookmarkSerializer < ResourceSerializer
  def instance_as_json(options={})
    logger.debug "resource => #{resource.inspect}"
    video = resource.video

    result = {
      version:  version,
      
      id:  resource.to_param,
      
      user_id: resource.user_id,
      video_id: resource.video_id,
      
      created_at:  resource.created_at,
      updated_at:  resource.updated_at,

      video_created_at:  video.created_at,
      video_updated_at:  video.updated_at
    }

    result
  end
end
