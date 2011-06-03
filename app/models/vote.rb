class Vote
  include Mongoid::Document

  field :score, :type => Integer

  embedded_in :entry
  belongs_to :user
end
