require 'mongoid'
require 'gravtastic'
require 'shoulda-matchers'
require File.expand_path('app/models/user')

describe User do

  it { should validate_presence_of(:login) }

end
