require 'spec_config'
require File.expand_path('lib/scores')

class ObjectWithScores
  include Scores
end

describe ObjectWithScores do

  describe '#calculate_average_score' do

    let(:object) do
      object = ObjectWithScores.new
      object.stubs(:participations).returns([])
      object
    end

    subject { object.calculate_average_score }

    it { should == 0.0 }

    context 'when having some participations' do

      before do
        object.stubs(:participations).returns([
          {'score' => 1.0}, {'score' => 2.0}, {'score' => 5.0}
        ])
      end

      it 'should calculate the average score' do
        should == 2.6666666666666667
      end

    end


  end

end
