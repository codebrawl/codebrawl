Fabricator(:suggestion) do
  name { Faker::Lorem.words.join(' ').capitalize }
end

