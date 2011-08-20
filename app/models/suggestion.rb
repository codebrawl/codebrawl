class Suggestion
  include Mongoid::Document
  include Mongoid::Timestamps

  field :name, :type => String
  field :votes, :type => Array

  validates :name, :presence => true
end
