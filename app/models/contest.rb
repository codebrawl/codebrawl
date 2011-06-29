class Contest
  include Mongoid::Document
  include Mongoid::Slug

  field :name, :type => String
  field :tagline, :type => String
  field :description, :type => String

  field :starting_on, :type => Date
  field :voting_on, :type => Date
  field :closing_on, :type => Date

  slug :name

  validates :user, :name, :description, :starting_on, :presence => true

  before_create :set_voting_and_closing_dates

  embeds_many :entries
  belongs_to :user

  def self.not_open
    Contest.all.reject { |contest| contest.open? }
  end

  def set_voting_and_closing_dates
    self.voting_on = starting_on + 1.week if self.voting_on.blank?
    self.closing_on = voting_on + 1.week if self.closing_on.blank?
  end

  def state
    case
    when Time.now.utc >= closing_at then 'closed'
    when Time.now.utc >= voting_at then 'voting'
    when Time.now.utc >= starting_at then 'open'
    else
      'pending'
    end
  end

  def pending?
    state == 'pending'
  end

  def open?
    state == 'open'
  end

  def voting?
    state == 'voting'
  end

  def closed?
    state == 'closed'
  end

  def starting_at
    starting_on.to_time.utc + 14.hours
  end

  def voting_at
    voting_on.to_time.utc + 14.hours
  end

  def closing_at
    closing_on.to_time.utc + 14.hours
  end

  def next_state_at
    case state
    when 'open' then voting_at
    when 'voting' then closing_at
    end
  end

end
