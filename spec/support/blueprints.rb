require 'machinist/mongoid'

Contest.blueprint do
  name 'Contest!'
  starts_at Time.now
end
