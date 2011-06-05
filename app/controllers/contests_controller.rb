class ContestsController < ApplicationController

  def index
    @contests = Contest.all.reject { |contest| contest.state == 'pending' }
  end

  def show
    @contest = Contest.find_by_slug(params[:id])
    @entry = @contest.entries.select{ |entry| entry.user == current_user }.first
  end

end
