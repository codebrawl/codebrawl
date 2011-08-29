require 'spec_config'
require File.expand_path('lib/points')

class ObjectWithPoints
  include Points
end

describe ObjectWithPoints do

  let(:object) do
    object = ObjectWithPoints.new
    object.stubs(:participations).returns([])
    object
  end

  describe '#calculate_points' do

    subject { object.calculate_points }

    it { should == 0 }

    context 'when having some participations' do

      before do
        object.stubs(:participations).returns([
          {'points' => 10},
          {'points' => 20},
          {'points' => 30}
        ])
      end

      it 'should calculate the total points' do
        should == 60
      end

    end

  end

  describe '#calculate_average_points' do

    subject { object.calculate_average_points }

    it { should == 0.0 }

    context 'when having participations with scores' do

      subject do
        object.stubs(:calculate_points).returns(80)
        object.stubs(:participations).returns([{},{},{}])
        object.calculate_average_points
      end

      it { should == 26.666666666666668 }

    end

  end

end

