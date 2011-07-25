Fabricator(:entry) do
  gist_id { '866948' }
  user
  contest
end

Fabricator(:entry_with_files, :from => :entry) do
  files {
    {
      'README' => { 'content' => Faker::Lorem.sentence(25) },
      'implementation*rb' => { 'content' => "def foo\n  bar + baz\nend"}
    }
  }
end
