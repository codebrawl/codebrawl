Fabricator(:user) do
  login { Faker::Internet.user_name }
end