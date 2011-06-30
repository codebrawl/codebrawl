class UsersController < ApplicationController

  def show
    @user = User.where(:login => params[:id]).first
    @entered_contests = Contest.all.where('entries.user_id' => @user.id).select do |contest|
      contest.state == 'finished'
    end
    @submitted_contests = Contest.all.where('user_id' => @user.id)
  end

end