module UserResourceableController
  def self.included(base)
    base.send :include, ::ResourceableController
    base.send :include, InstanceMethods
    base.send :before_filter, :user_scope
  end
  
  module InstanceMethods
    def user_scope
      user_id = params[:user_id] == 'me' ? session[:user_id] : params[:user_id]
      @user_scope ||= User.where(id: user_id).first
    end

    def resource_collection_url
      send "api_user_#{self.class.name.split('::').last.gsub(/Controller$/, '').tableize}_url", :user_id => user_scope.to_param
    end

    def resource_collection_path
      send "api_user_#{self.class.name.split('::').last.gsub(/Controller$/, '').tableize}_path", :user_id => user_scope.to_param
    end

    def resource_instance_url(options)
      options[:user_id] ||= user_scope.to_param
      send "api_user_#{self.class.name.split('::').last.gsub(/Controller$/, '').underscore}_url", options
    end

    def resource_instance_path(options)
      options[:user_id] ||= user_scope.to_param
      send "api_user_#{self.class.name.split('::').last.gsub(/Controller$/, '').underscore}_path", options
    end
  end
end
