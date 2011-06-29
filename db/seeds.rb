require 'fabrication'
require 'faker'
require 'vcr'

VCR.config do |c|
  c.cassette_library_dir = 'spec/fixtures/vcr_cassettes'
  c.stub_with :fakeweb
end

Dir[Rails.root.join("spec/fabricators/**/*.rb")].each {|f| require f}
[Contest, User].each { |model| model.delete_all }

users = {
  'alice' => Fabricate(:user, :login => 'alice'),
  'bob' => Fabricate(:user, :login => 'bob'),
  'charlie' => Fabricate(:user),
}

VCR.use_cassette('existing_gist') do
  %w{ alice bob charlie }.each_with_index do |login, index|
    contest = Fabricate(
      :contest,
      :starting_on => (index.weeks + 1.day).ago.to_time,
      :user => users[login]
    )

    %w{ alice bob charlie }.each do |login|
      Fabricate(:entry_with_files, :contest => contest, :user => users[login])
    end
  end
end
