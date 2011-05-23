class Contest
  include Mongoid::Document

  field :name, :type => String
  field :description, :type => String

  field :starting_on, :type => Date
  field :voting_on, :type => Date
  field :closing_on, :type => Date

  validates :name, :description, :starting_on, :presence => true

  before_create :set_voting_and_closing_dates

  def set_voting_and_closing_dates
    self.voting_on = starting_on + 1.week
    self.closing_on = voting_on + 1.week
  end

  def state
    case
    when Time.now.utc >= closing_on.to_time.utc + 16.hours
      'closed'
    when Time.now.utc >= voting_on.to_time.utc + 16.hours
      'voting'
    when Time.now.utc >= starting_on.to_time.utc + 16.hours
      'open'
    else
      'pending'
    end
  end

end
