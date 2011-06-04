class VotesController < ApplicationController

  def create
    @contest = Contest.find_by_slug(params[:contest_id])

    unless params[:votes].blank?
      params[:votes].each do |key, value|
        @contest.entries.find(key).votes.create!(value.merge({:user_id => current_user.id}))
      end
    end

    redirect_to @contest
  end

end