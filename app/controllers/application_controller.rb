class ApplicationController < ActionController::Base
  protect_from_forgery

  protected

    def current_user
      @current_user ||= User.find(session[:user_id]) rescue nil if session[:user_id]
    end

    def logged_in?
      current_user.present?
    end

    def authenticate_user!
      redirect_to "/auth/github?origin=#{request.env['PATH_INFO']}" unless logged_in?
    end

    helper_method :current_user, :logged_in?
end
