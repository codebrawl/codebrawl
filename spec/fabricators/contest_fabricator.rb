Fabricator(:contest) do
  name { Faker::Lorem.words.join(' ').capitalize }
  tagline { Faker::Lorem.sentence(7) }
  description { Faker::Lorem.sentence(25) }
  starting_on { Date.parse('May 23 2011') }
  tagline { Faker::Lorem.sentence(25) }
  user
end

Fabricator(:contest_open, :from => :contest) do
  starting_on { Date.yesterday.to_time }
end

Fabricator(:contest_voting, :from => :contest) do
  voting_on { Date.yesterday.to_time }
end

Fabricator(:contest_finished, :from => :contest) do
  closing_on { Date.yesterday.to_time }
end
