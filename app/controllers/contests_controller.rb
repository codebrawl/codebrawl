class ContestsController < ApplicationController
  def index
    return redirect_to root_path if request.path == '/contests'

    @contests = Contest.active

    respond_to do |format|
      format.html
      format.atom { render :layout => false }
    end
  end

  def show
    @contest = Contest.find_by_slug(params[:id])
    if current_user
      @voted_entries = current_user.voted_entries(@contest)
      @entry = @contest.entries.where(:user_id => current_user.id).first
    end
    @voted_entries ||= []
  end

end
