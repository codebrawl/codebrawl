class Ranking
  include Mongoid::Document
  embedded_in :user
end
