class ContestsController < ApplicationController
  def index
    @contests = Contest.active

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @contest = Contest.by_slug(params[:id])
    @entry = @contest.entries.by_user(current_user)

    @voted_entries = @contest.voted_entries(current_user) if current_user

    @voted_entries ||= []
  end

end
