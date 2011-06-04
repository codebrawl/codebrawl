class UsersController < ApplicationController

  def show
    @user = User.where(:login => params[:id]).first
    @contests = Contest.all.where('entries.user_id' => @user.id)
  end

end