class Contest
  include Mongoid::Document

  field :name, :type => String

  field :starting_on, :type => Date
  field :voting_on, :type => Date
  field :closing_on, :type => Date

  field :state, :type => String, :default => 'open'

  validates :name, :starting_on, :presence => true

  before_create :set_voting_and_closing_dates

  def set_voting_and_closing_dates
    self.voting_on = starting_on + 1.week
    self.closing_on = voting_on + 1.week
  end

end
