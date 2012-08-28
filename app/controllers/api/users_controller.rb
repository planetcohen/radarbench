module Api
  class UsersController < BaseController
    include ResourceableController
    #before_filter :signin_required, except: [:index, :create, :authenticate]

    #def index
    #  render nothing: true, status: :method_not_allowed
    #end
    #
    #def create
    #  render nothing: true, status: :method_not_allowed
    #end

    #if Rails.env.development? or Rails.env.test?
    #  def authenticate
    #    logger.debug "UsersController#authenticate(email => #{params[:email]}, password => #{params[:password]})"
    #    return render(nothing: true, status: :unauthorized) if params[:email].blank? || params[:password].blank?
    #    user = signin_with_email_and_password params[:email], params[:password]
    #    if user.present?
    #      present_instance(user, params)
    #    else
    #      render nothing: true, status: :unauthorized
    #    end
    #  end
    #end

    private
    def find_instance
      @instance = if params[:id] == 'me' 
        current_user
      else
        User.where(id: params[:id]).first
      end
      head :status => :not_found if @instance.nil?
      @instance
    end
    
    def update_resource_params
      result = params.slice(
                  :id, :email, :first_name, :last_name,
                  :fb_uid, :fb_access_token, #:fb_pic_square,
                  :tw_oauth_token, :tw_oauth_secret)

      #if result.has_key? :had_first_run
      #  result[:first_run] = result[:had_first_run]
      #  result.delete :had_first_run
      #end
      #
      #if result[:prefs].present?
      #  result[:prefs] = result[:prefs].to_json  unless result[:prefs].instance_of?(String)
      #else
      #  result.delete :prefs
      #end

      result
    end
  end
end
