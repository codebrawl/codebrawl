require 'machinist/mongoid'
require 'faker'

Contest.blueprint do
  name { Faker::Lorem.words.join(' ').capitalize }
  tagline { Faker::Lorem.sentence(7) }
  description { Faker::Lorem.sentence(25) }
  starting_on { Date.parse('May 23 2011') }
end

Entry.blueprint do
  gist_id { (rand * 100000).to_i }
  user { User.make }
end

Entry.blueprint(:with_files) do
  files {
    { 'README' => { 'content' => description { Faker::Lorem.sentence(25) } }}
  }
end

User.blueprint do
  login { Faker::Internet.user_name }
end

Vote.blueprint {}
Comment.blueprint {}
