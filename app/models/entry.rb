class Entry
  include Mongoid::Document

  field :description, :type => String
  field :score, :type => Float, :default => 0.0

  validates :user, :description, :presence => true

  embedded_in :contest
  embeds_many :votes
  belongs_to :user

  def calculate_scrore
    votes.map(&:score).inject { |sum, el| sum + el }.to_f / votes.length
  end

  def score
    read_attribute(:score).nonzero? || write_attribute(:score, calculate_scrore).last
  end
end
