require 'spec_helper'
require 'support/mongoid_matchers'

describe Ranking do

  it { should be_embedded_in(:user) }

end
