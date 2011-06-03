class Entry
  include Mongoid::Document

  field :description, :type => String

  validates :user, :description, :presence => true

  embedded_in :contest
  embeds_many :votes
  belongs_to :user
end
