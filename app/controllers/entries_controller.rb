class EntriesController < ApplicationController

  def new
    @contest = Contest.find_by_slug(params[:contest_id])
  end

end
