require 'wufoo'

class SubmissionsController < ApplicationController
  before_filter :require_login

  def create
    if Submission.create(:user => current_user, :idea => params['idea'])
      redirect_to root_path, :notice => 'Thanks for your submission! We\'ll check it out and let you know if we decide to use it.'
    else
      redirect_to root_path, :alert => 'Something went wrong while sending your suggestion. Please try again later.'
    end
  end
end
