class SuggestionsController < ApplicationController

  def index
    @suggestions = Suggestion.all
  end

end
