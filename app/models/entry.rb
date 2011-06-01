class Entry
  include Mongoid::Document

  field :description, :type => String

  validates :user, :description, :presence => true

  embedded_in :contest
  belongs_to :user
end
