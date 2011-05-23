require 'spec_helper'

describe Contest do

  context '.make' do

    it { Contest.make.should be_valid }

  end

  context '.save!' do

    context 'when keeping all fields empty' do

      it { should have_a_presence_error_on(:name) }

      it { should have_a_presence_error_on(:starts_on) }

    end

    context 'when creating a valid contest' do

      subject { Contest.make }

      it { should be_open }

    end

  end

end
