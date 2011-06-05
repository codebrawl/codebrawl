class EntriesController < ApplicationController

  def new
    redirect_to "/auth/github?origin=#{request.env['PATH_INFO']}" unless logged_in?

    @contest = Contest.find_by_slug(params[:contest_id])

    unless @contest.entries.select{ |entry| entry.user == current_user }.blank?
      redirect_to @contest, :alert => 'You already have an entry for this contest. Don\'t worry, though. You can always update your entry using the form below.'
    end

    @entry = @contest.entries.new
  end

  def create
    @contest = Contest.find_by_slug(params[:contest_id])
    @contest.entries.create!(params[:entry].merge({:user_id => current_user.id}))
    redirect_to @contest, :notice => 'Thank you for entering!'
  end

  def update
    @contest = Contest.find_by_slug(params[:contest_id])
    @entry = @contest.entries.find(params[:id])
    @entry.update_attributes(params[:entry])
    redirect_to @contest, :notice => 'Your entry has been updated.'
  end

  def destroy
    @contest = Contest.find_by_slug(params[:contest_id])
    @entry = @contest.entries.find(params[:id])
    @entry.destroy
    redirect_to @contest, :notice => 'Your entry has been deleted.'
  end

end
