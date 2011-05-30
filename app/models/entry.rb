class Entry
  include Mongoid::Document

  field :description, :type => String

  validates :user, :presence => true

  embedded_in :contest
  belongs_to :user
end
