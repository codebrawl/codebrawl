require 'spec_helper'

describe User do

  context '.make' do

    it { User.make.should be_valid }

  end

end
