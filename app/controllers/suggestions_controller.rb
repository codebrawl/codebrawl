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
    @suggestion.votes << { 'score' => params[:suggestion][:score].to_i }
    @suggestion.save

    redirect_to :suggestions, :notice => 'Thanks for voting!'
  end

end
