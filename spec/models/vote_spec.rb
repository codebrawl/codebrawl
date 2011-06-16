require 'spec_helper'

describe Vote do

  context 'fabrication' do

    it { Fabricate(:vote).should be_valid }

  end

end
