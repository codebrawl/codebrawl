class Vote
  include Mongoid::Document

  field :score, :type => Integer

  attr_accessor :comment

  embedded_in :entry
  belongs_to :user
end
