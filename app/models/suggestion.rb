class Suggestion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :description, :type => String
  field :votes, :type => Array, :default => []

  validates :name, :presence => true

  def add_vote!(attributes)
    votes << {'score' => attributes[:score].to_i }
    save!
  end

  def score
    votes.map {|vote| vote['score'] }.inject(&:+) || 0
  end

end
