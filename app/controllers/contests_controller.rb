class ContestsController < ApplicationController

  def index
    redirect_to root_path unless request.path == root_path
    @contests = Contest.all.order_by([:starting_on, :desc]).reject do |contest|
      contest.state == 'pending'
    end
  end

  def show
    @contest = Contest.find_by_slug(params[:id])
    if current_user
      @voted_entries = @contest.entries.select do |entry|
        entry.votes.map(&:user_id).include? current_user.id
      end
      @entry = @contest.entries.select{ |entry| entry.user == current_user }.first
    end
    @voted_entries ||= []
  end

end
