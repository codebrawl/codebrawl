class EntriesController < ApplicationController
  before_filter :authenticate_user!, :only => :new
  before_filter :find_contest

  def new
    @contest = @contest.if_open
    @entry = @contest.entries.new

    @contest.not_found if @contest.has_entry_from?(current_user)
  end

  def create
    @entry = @contest.entries.new(params[:entry].merge({:user_id => current_user.id}))
    if @entry.save
      redirect_to @contest, :notice => 'Thank you for entering!'
    else
      render :new
    end
  end

  def destroy
    @entry = @contest.entries.find(params[:id])
    @entry.destroy
    redirect_to @contest, :notice => 'Your entry has been deleted.'
  end

  protected

    def find_contest
      @contest = Contest.find_by_slug(params[:contest_id])
    end
end
