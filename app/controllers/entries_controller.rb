class EntriesController < ApplicationController
  before_filter :authenticate_user!, :only => :new

  def new
    @contest = Contest.find_by_slug(params[:contest_id])

    unless @contest.entries.select{ |entry| entry.user == current_user }.blank?
      redirect_to @contest, :alert => 'You already have an entry for this contest.'
    end

    @entry = @contest.entries.new
  end

  def create
    @contest = Contest.find_by_slug(params[:contest_id])
    @entry = @contest.entries.new(params[:entry].merge({:user_id => current_user.id}))
    if @entry.save
      redirect_to @contest, :notice => 'Thank you for entering!'
    else
      render :new
    end
  end

  def destroy
    @contest = Contest.find_by_slug(params[:contest_id])
    @entry = @contest.entries.find(params[:id])
    @entry.destroy
    redirect_to @contest, :notice => 'Your entry has been deleted.'
  end

end
