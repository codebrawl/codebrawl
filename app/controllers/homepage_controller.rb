class HomepageController < ApplicationController

  def index
    @contests = Contest.active[0..1]
  end

end
