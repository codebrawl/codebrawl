require 'wufoo'

class SubmissionsController < ApplicationController
  before_filter :authenticate_user!, :only => :new

  def create
    client = Wufoo::Client.new('http://codebrawl.wufoo.com', Codebrawl.config.wufoo.api_key)
    submission = Wufoo::Submission.new(client, 'contest-submission')

    response = submission.add_params({
      '1'  => current_user.login,
      '103' => params['idea'],
    }).process

    if response.success?
      redirect_to root_path, :notice => 'Thanks for your submission! We\'ll check it out and let you know if we decide to use it.'
    else
      redirect_to root_path, :alert => 'Something went wrong while sending your submission. Please try again later.'
    end
  end
end
