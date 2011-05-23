require 'machinist/mongoid'

Contest.blueprint do
  name 'Contest!'
  starting_on Date.parse('May 23 2011')
end
