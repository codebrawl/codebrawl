require 'spec_helper'

describe User do

  context '.make' do

    it { User.make.should be_valid }

  end

  context '#save!' do

    context 'when keeping all fields empty' do

      it { should have_a_presence_error_on(:login) }

    end

  end

end
