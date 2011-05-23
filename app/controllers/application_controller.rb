class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    @contests = Contest.all.reject { |contest| contest.state == 'pending' }
  end

end
