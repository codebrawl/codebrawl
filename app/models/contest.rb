class Contest
  include Mongoid::Document

  field :name, :type => String
  field :starts_at, :type => DateTime
  field :state, :type => String, :default => 'open'

  validates :name, :starts_at, :presence => true
end
