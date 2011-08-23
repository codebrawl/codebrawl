class UsersController < ApplicationController

  def index
    @users = User.all.order_by([
      [:points, :desc],
      [:average_score, :desc]
    ]).select { |user| user.points && user.points > 0 }

    @positions = @users.map(&:id)
  end

  def contributors
    @users = User.where(:contributions.gt => 0)
    @positions = User.only(:id).order_by([
      [:points, :desc],
      [:average_score, :desc]
    ]).map(&:id)

    render :action => :index
  end

  def show
    @users = User.only(:id).order_by([
      [:points, :desc],
      [:average_score, :desc]
    ]).map(&:id)

    not_found unless @user = User.where(:login => params[:id]).first
    @entered_contests = Contest.all.where('entries.user_id' => @user.id).select do |contest|
      contest.state == 'finished'
    end
    @submitted_contests = Contest.all.where('user_id' => @user.id)
    @medals = { 1 => 'medal_gold', 2 => 'medal_silver', 3 => 'medal_bronze'}
    @medals.default = 'rosette'
  end

end
