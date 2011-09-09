require 'spec_config'
require File.expand_path('lib/array_average')

describe Array do

  let(:array) { [] }

  describe '#average' do

    subject { array.average }

    it { should == 0.0 }

    context 'when having nil as the only value' do

      let(:array) { [nil] }

      it { should == 0.0 }

    end

    context 'when having 1 and 5 as values' do

      let(:array) { [1,5] }

      it { should == 3 }

    end

    context 'when having nil and 4 as values' do

      let(:array) { [nil, 4] }

      it { should == 4 }

    end

  end

end
