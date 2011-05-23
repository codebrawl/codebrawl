class Contest
  include Mongoid::Document

  field :name, :type => String

  field :starts_on, :type => Date
  field :voting_on, :type => Date

  field :state, :type => String, :default => 'open'

  validates :name, :starts_on, :presence => true

  before_create :set_voting_date

  def set_voting_date
    self.voting_on = starts_on + 1.week
  end

end
