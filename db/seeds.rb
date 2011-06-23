require 'fabrication'
require 'faker'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.stub_with :fakeweb
end

Dir[Rails.root.join("spec/fabricators/**/*.rb")].each {|f| require f}
[Contest, User].each { |model| model.delete_all }

VCR.use_cassette('existing_gist') do
  3.times do |i|
    contest = Fabricate(
      :contest,
      :starting_on => (i.weeks + 1.day).ago.to_time,
    )

    3.times { Fabricate(:entry_with_files, :contest => contest) }
  end
end
