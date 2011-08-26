class SuggestionVotesController < ApplicationController

  def create
    @suggestion = Suggestion.find(params[:suggestion_id])
    @suggestion.votes.create!(params[:suggestion_vote])
    redirect_to :suggestions, :notice => 'Thanks for voting!'
  end

end
