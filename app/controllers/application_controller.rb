class ApplicationController < ActionController::Base
  protect_from_forgery

  def index
    @contests = Contest.all
  end

end
