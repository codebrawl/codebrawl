class Suggestion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String

  validates :name, :presence => true
end
