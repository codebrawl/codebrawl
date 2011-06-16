require 'fabrication'
require 'faker'

Dir[Rails.root.join("spec/fabricators/**/*.rb")].each {|f| require f}
[Contest, User].each { |model| model.delete_all }

3.times do |i|
  Fabricate(
    :contest,
    :starting_on => (i.weeks + 1.day).ago.to_time,
    :entries => [
      Fabricate(:entry, :gist_id => '830060'),
      Fabricate(:entry, :gist_id => '813725'),
      Fabricate(:entry, :gist_id => '676219')
    ]
  )
end
