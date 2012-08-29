module Api
  class BookmarksController < BaseController
    include UserResourceableController
    
    def benchmark
      @instance = resources_scope.build video: Video.first
      logger.debug "@instance => #{@instance.inspect}"
      if @instance.save
        logger.debug "@instance => #{@instance.inspect}"
        serialize_instance @instance, params
      else
        logger.debug "@instance.errors => #{@instance.errors.inspect}"
        render :json => @instance.errors.to_json, :status => :unprocessable_entity
      end
    end
    
    protected
    def resources_scope
      user_scope.bookmarks
    end
  end
end
