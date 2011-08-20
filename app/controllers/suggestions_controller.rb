class SuggestionsController < ApplicationController

  def index
    @suggestions = Suggestion.all.sort do |a,b|
      b_score = b.votes.map {|vote| vote['score'] }.inject(&:+)
      a_score = a.votes.map {|vote| vote['score'] }.inject(&:+)

      b_score || 0 <=> a_score || 0
    end
  end

  def create
    Suggestion.create(params[:suggestion])
    redirect_to :suggestions, :notice => 'Thanks for your suggestion!'
  end

  def update
    @suggestion = Suggestion.find(params[:id])
    @suggestion.votes << { 'score' => params[:commit].to_i }
    @suggestion.save

    redirect_to :suggestions, :notice => 'Thanks for voting!'
  end

end
