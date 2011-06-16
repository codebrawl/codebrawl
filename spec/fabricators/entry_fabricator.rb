Fabricator(:entry) do
  gist_id { (rand * 100000).to_i }
  user
  contest
end

Fabricator(:entry_with_files, :from => :entry) do
  files {
    { 'README' => { 'content' => Faker::Lorem.sentence(25) } }
  }
end