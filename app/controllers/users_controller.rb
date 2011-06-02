class UsersController < ApplicationController

  def show
    @user = User.where(:login => params[:id]).first
  end

end