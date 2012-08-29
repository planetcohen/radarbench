class BenchmarksController < ApplicationController
  include SerializableController

  def text
    render text: "hey there"
  end
  
  def template
  end
  
  def db_read
    @instance = find_user
    serialize_instance @instance, params
  end
  
  def db_write
    @user = find_user
    @instance = @user.bookmarks.build video: Video.first
    #logger.debug "@instance => #{@instance.inspect}"
    if @instance.save
      #logger.debug "@instance => #{@instance.inspect}"
      serialize_instance @instance, params
    else
      #logger.debug "@instance.errors => #{@instance.errors.inspect}"
      render :json => @instance.errors.to_json, :status => :unprocessable_entity
    end
  end
  
  private
  def find_user
    User.first
  end
end
