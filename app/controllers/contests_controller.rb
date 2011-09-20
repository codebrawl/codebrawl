class ContestsController < ApplicationController
  def index
    @contests = Contest.active

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    not_found unless @contest = Contest.find_by_slug(params[:id])

    if current_user
      @voted_entries = @contest.voted_entries(current_user)
      @entry = @contest.entries.where(:user_id => current_user.id).first
    end
    @voted_entries ||= []
  end

end
