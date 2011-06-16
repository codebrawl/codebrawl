Fabricator(:contest) do
  name { Faker::Lorem.words.join(' ').capitalize }
  tagline { Faker::Lorem.sentence(7) }
  description { Faker::Lorem.sentence(25) }
  starting_on { Date.parse('May 23 2011') }
end