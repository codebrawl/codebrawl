class VotesController < ApplicationController

  def create
    @contest = Contest.find_by_slug(params[:contest_id])
    @entry = @contest.entries.find(params[:entry_id])
    if params[:vote]
      @entry.votes.create!(params[:vote].merge({:user_id => current_user.id}))
    end

    respond_to do |format|
      format.html { redirect_to @contest }
      format.js { render :nothing => true }
    end
  end

end