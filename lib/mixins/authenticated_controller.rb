module AuthenticatedController
  USERNAME, PASSWORD = 'butterfly', 'elliott'

  def self.included(base)
    base.send :before_filter, :require_authentication  unless Rails.env.development?
  end
  
  private
  def require_authentication
    authenticate_or_request_with_http_basic do |username, password|
      username == USERNAME && password == PASSWORD
    end
  end
end
