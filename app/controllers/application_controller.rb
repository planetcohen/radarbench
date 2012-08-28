class ApplicationController < ActionController::Base
  protect_from_forgery

  protected
  def boolean_from_param_value(param_value)
    return true if param_value == true || param_value =~ (/(true|t|yes|y|1)$/i)
    return false if param_value == false || param_value.nil? || param_value =~ (/(false|f|no|n|0)$/i)
    raise ArgumentError.new("invalid value for Boolean: #{param_value}")
  end
end
