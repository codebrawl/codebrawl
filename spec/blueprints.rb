require 'machinist/mongoid'
require 'sham'
require 'faker'

Contest.blueprint do
  name { Faker::Lorem.words }
end
