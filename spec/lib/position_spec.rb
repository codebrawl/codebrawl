require 'spec_config'
require File.expand_path('lib/position')

class ObjectWithPosition
  include Position
end

describe Position do

  describe '#calculate_average_position' do

    let(:object) { ObjectWithPosition.new }

    before { object.stubs(:participations).returns({}) }

    subject { object.calculate_average_position }

    it { should == 0.0 }

    context 'when having positions of 2 and 5' do

      before do
        object.stubs(:participations).returns([
          {'position' => 2}, {'position' => 5}
        ])
      end

      it { should == 3.5 }

    end

    context 'when having an empty position and positions of 1 and 3' do

      before do
        object.stubs(:participations).returns([
          {}, {'position' => 1}, {'position' => 2}
        ])
      end

      it { should == 1.5 }
    end

  end

end
