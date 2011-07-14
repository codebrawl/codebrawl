class VotesController < ApplicationController

  def create
    @contest = Contest.find_by_slug(params[:contest_id])
    @entry = @contest.entries.find(params[:entry_id])

    if params[:vote][:score]
      @entry.votes.create!({
        :user_id => current_user.id,
        :score => params[:vote][:score]
      })
    end

    unless params[:vote][:comment].empty?
      Gist.comment(@entry.gist_id, current_user.token, params[:vote][:comment])
    end

    respond_to do |format|
      format.html { redirect_to @contest }
      format.js { render :nothing => true }
    end
  end

end