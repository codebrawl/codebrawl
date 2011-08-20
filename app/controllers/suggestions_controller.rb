class SuggestionsController < ApplicationController

  def index
    @suggestions = Suggestion.all
  end

  def update
    @suggestion = Suggestion.find(params[:id])

    @suggestion.votes << { 'score' => params[:suggestion][:score].to_i }
    @suggestion.save

    redirect_to :suggestions, :notice => 'Thanks for voting!'
  end

end
