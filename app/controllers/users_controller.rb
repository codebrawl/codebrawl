class UsersController < ApplicationController

  def index
    @users = User.all.order_by([
      [:points, :desc],
      [:average_score, :desc]
    ]).select { |user| user.points && user.points > 0 }

    @points = @users.map(&:points)
  end

  def show
    @users = User.only(:id).order_by([:points, :desc]).map(&:id)

    not_found unless @user = User.where(:login => params[:id]).first
    @entered_contests = Contest.all.where('entries.user_id' => @user.id).select do |contest|
      contest.state == 'finished'
    end
    @submitted_contests = Contest.all.where('user_id' => @user.id)
  end

end