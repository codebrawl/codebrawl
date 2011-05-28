class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']
    parameters = { :login => auth['user_info']['nickname'], :github_id => auth['uid'] }

    user = User.first(:conditions => parameters) || User.create(parameters)
    session[:user_id] = user.id

    redirect_to root_path
  end

end
