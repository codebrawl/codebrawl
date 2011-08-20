require 'spec_helper'

describe Suggestion do

  context 'fabrication' do

    subject { Fabricate(:suggestion) }

    it { should be_valid }

    it { should have_a_created_at_date }

  end

  context '#save!' do

    it { should have(1).error_on(:name) }

  end

  context '#votes' do

    subject { Fabricate.build(:suggestion).votes }

    it { should == [] }

  end

end
