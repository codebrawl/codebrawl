require 'wufoo'

class SubmissionsController < ApplicationController
  def new
    redirect_to "/auth/github?origin=#{request.env['PATH_INFO']}" unless logged_in?
  end

  def create
    client = Wufoo::Client.new(Codebrawl.config['wufoo']['url'], Codebrawl.config['wufoo']['api_key'])
    submission = Wufoo::Submission.new(client, Codebrawl.config['wufoo']['form'])

    response = submission.add_params({
      '1'  => current_user.login,
      '103' => params['idea'],
    }).process

    redirect_to root_path, :notice => 'Thanks for your submission! We\'ll check it out and let you know if we decide to use it.'
  end
end
