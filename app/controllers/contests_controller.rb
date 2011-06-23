class ContestsController < ApplicationController

  def create
    @contest = Contest.new(params[:contest])
    if @contest.save
      redirect_to @contest
    end
  end

  def new
    @contest = Contest.new
  end

  def index
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
