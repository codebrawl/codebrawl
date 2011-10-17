require File.expand_path('app/models/user')
require 'shoulda-matchers'

describe User do

  it { should validate_presence_of(:login) }

end
