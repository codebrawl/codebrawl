require 'spec_helper'

describe Suggestion do

  context 'fabrication' do

    subject { Fabricate(:suggestion) }

    it { should be_valid }

    it { should have_a_created_at_date }

  end

end
