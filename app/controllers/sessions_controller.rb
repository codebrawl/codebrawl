class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']

    parameters = { :login => auth['user_info']['nickname'], :github_id => auth['uid'] }

    user = User.first(:conditions => parameters) || User.create(parameters.merge(auth['user_info']))
    session[:user_id] = user.id

    redirect_to request.env['omniauth.origin'] || contests_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to contests_path
  end

  def failure
    redirect_to contests_path, :alert => 'Something went wrong while trying to log you in.'
  end

end
