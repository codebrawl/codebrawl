class Contest
  include Mongoid::Document

  field :name, :type => String
  field :starts_at, :type => DateTime

  validates :name, :starts_at, :presence => true
end
