require 'spec_helper'

describe Entry do

  context '.make' do

    it { Entry.make.should be_valid }

  end

end
