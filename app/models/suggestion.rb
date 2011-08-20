class Suggestion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :votes, :type => Array, :default => []

  validates :name, :presence => true

  def score
    votes.map {|vote| vote['score'] }.inject(&:+) || 0
  end

end
