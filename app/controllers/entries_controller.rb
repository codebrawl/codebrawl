class EntriesController < ApplicationController

  def new
    @contest = Contest.find_by_slug(params[:contest_id])
    @entry = @contest.entries.new
  end

  def create
    @contest = Contest.find_by_slug(params[:contest_id])
    @contest.entries.create!(params[:entry].merge({:user_id => current_user.id}))
    redirect_to @contest, :notice => 'Thank you for entering!'
  end

end
