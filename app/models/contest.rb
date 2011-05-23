class Contest
  include Mongoid::Document

  field :name, :type => String

  field :starts_on, :type => Date
  field :duration, :type => Integer, :default => 1.week

  field :state, :type => String, :default => 'open'

  validates :name, :starts_on, :presence => true
end
