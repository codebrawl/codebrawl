require 'state'
require 'time_from_date_field'

class Contest
  include Mongoid::Document
  include Mongoid::Timestamps
  include Mongoid::Slug

  field :name, :type => String
  field :tagline, :type => String
  field :description, :type => String

  field :starting_on, :type => Date
  field :voting_on, :type => Date
  field :closing_on, :type => Date

  slug :name

  include TimeFromDateField
  include State

  validates :user, :name, :description, :starting_on, :tagline, :presence => true
  validates :tagline, :length => { :minimum => 50 }

  before_create :set_voting_and_closing_dates

  embeds_many :entries
  belongs_to :user

  def self.not_open
    Contest.all.reject { |contest| contest.open? }
  end

  def self.active
    scoped.order_by([:starting_on, :desc]).reject { |c| c.pending? }
  end

  def set_voting_and_closing_dates
    self.voting_on = starting_on + 1.week if self.voting_on.blank?
    self.closing_on = voting_on + 1.week if self.closing_on.blank?
  end

  def add_participations_to_contestants!
    entries.order_by([:score, :desc]).each_with_index do |entry, index|
      entry.user.participations << {
        'contest_id' => id,
        'contest_name' => name,
        'contest_slug' => slug,
        'points' => (entries.length.max(10) - index).min(1) * 10,
        'score' => entry.read_attribute(:score),
        'position' => index + 1
      } unless entry.user.participation_for? self
      entry.user.save!
    end
  end

  def has_entry_from?(user)
    entries.where(:user_id => user.id).any?
  end

  def voted_entries(user)
    entries.select { |e| e.votes_from?(user) }
  end

end
