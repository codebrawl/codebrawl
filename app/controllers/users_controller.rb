class UsersController < ApplicationController

  def index
    @users = User.all.order_by([:points, :desc]).select { |user| user.points > 0 }
  end

  def show
    @user = User.where(:login => params[:id]).first
    @entered_contests = Contest.all.where('entries.user_id' => @user.id).select do |contest|
      contest.state == 'finished'
    end
    @submitted_contests = Contest.all.where('user_id' => @user.id)
  end

end