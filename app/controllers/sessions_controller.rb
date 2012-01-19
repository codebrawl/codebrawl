class SessionsController < ApplicationController

  def create
    auth = request.env['omniauth.auth']
    parameters = { :login => auth['info']['nickname'], :github_id => auth['uid'] }

    if user = User.first(:conditions => parameters)
      user.update_attributes(:token => auth['credentials']['token']) unless user.token?
    else
      user = User.create(
        parameters.
        merge(auth['info']).
        merge({
          :token => auth['credentials']['token'],
          :gravatar_id => auth['extra']['raw_info']['gravatar_id']
        })
      )
    end

    session[:user_id] = user.id

    redirect_to request.env['omniauth.origin'] || root_path
  end

  def destroy
    session[:user_id] = nil
    redirect_to root_path
  end

  def failure
    redirect_to root_path, :alert => 'Something went wrong while trying to log you in.'
  end

end
