class Entry
  include Mongoid::Document

  field :description, :type => String

  validates :user, :description, :presence => true

  embedded_in :contest
  embeds_many :votes
  belongs_to :user

  def score
    read_attribute(:score) || sprintf("%.1f", votes.map(&:score).inject { |sum, el| sum + el }.to_f / votes.length).to_f
  end
end
