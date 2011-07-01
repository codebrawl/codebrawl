class ContestsController < ApplicationController
  before_filter :require_login, :only => [:new, :create, :edit, :update]
  before_filter :build_contest, :only => [:new, :create]
  before_filter :find_contest_from_user, :only => [:edit, :update]

  def create
    if @contest.save
      redirect_to @contest
    end
  end

  def update
    if @contest.update_attributes(params[:contest])
      redirect_to @contest
    else
      edit
    end
  end

  def index
    @contests = Contest.all.order_by([[:featured, :desc], [:starting_on, :desc]]).reject(&:pending?)

    respond_to do |format|
      format.html { redirect_to root_path unless request.path == root_path }
      format.atom { render :layout => false }
    end
  end

  def show
    @contest = Contest.find_by_slug(params[:id])
    if current_user
      @voted_entries = @contest.entries.select do |entry|
        entry.votes.map(&:user_id).include? current_user.id
      end
      @entry = @contest.entries.detect{ |entry| current_user.created?(entry) }
    end
    @voted_entries ||= []
  end

  private

    def build_contest
      @contest = current_user.contests.build(params[:contest])
    end

    def find_contest_from_user
      head :unauthorized unless @contest = current_user.contests.find_by_slug(params[:id])
    end
end
