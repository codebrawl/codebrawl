class Vote
  include Mongoid::Document

  field :score, :type => Integer
end
