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
      @voted_entries = @contest.entries.select do |entry|
        entry.votes.map(&:user_id).include? current_user.id
      end
      @entry = @contest.entries.select{ |entry| entry.user == current_user }.first
    end
    @voted_entries ||= []
  end

end
