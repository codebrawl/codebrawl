require 'spec_config'
require File.expand_path('lib/points')

class ObjectWithPoints
  include Points
end

describe ObjectWithPoints do

  describe '#calculate_points' do

    let(:object) do
      object = ObjectWithPoints.new
      object.stubs(:participations).returns([])
      object
    end

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

end

