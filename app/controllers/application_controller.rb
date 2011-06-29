class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

    def current_user
      @current_user ||= User.find(session[:user_id]) rescue nil if session[:user_id]
    end

    def logged_in?
      current_user.present?
    end

    helper_method :current_user, :logged_in?

    def require_login
      redirect_to "/auth/github?origin=#{request.path}" unless logged_in?
    end
end
