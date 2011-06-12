class ContestsController < ApplicationController

  def index
    @contests = Contest.all.order_by([:starting_on, :desc]).reject do |contest|
      contest.state == 'pending'
    end
  end

  def show
    @contest = Contest.find_by_slug(params[:id])
    if current_user
      @voted_entries = @contest.entries.select {|entry| entry.votes.map(&:user_id).include? current_user.id }
      @entry = @contest.entries.select{ |entry| entry.user == current_user }.first
    end
  end

end
