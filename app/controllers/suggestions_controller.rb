class SuggestionsController < ApplicationController

  def index
    @suggestions = Suggestion.all.sort { |a,b| b.score <=> a.score }
  end

  def create
    Suggestion.create(params[:suggestion])
    redirect_to :suggestions, :notice => 'Thanks for your suggestion!'
  end

  def update
    @suggestion = Suggestion.find(params[:id])
    @suggestion.add_vote!(params[:suggestion])
    redirect_to :suggestions, :notice => 'Thanks for voting!'
  end

end
