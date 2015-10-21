class ApplicationController < ActionController::Base
	 include CanCan::ControllerAdditions
	 before_action :authenticate_user!
  # Prevent CSRF attacks by raising an exception.
  # For APIs, you may want to use :null_session instead.

helper_method :current_user

 def current_user
	@current_user ||= User.find_by_id(session[:user_id])
 end


  protect_from_forgery with: :exception 
end
