require 'spec_config'
require File.expand_path('lib/participations')

class ObjectWithParticipations
  include Participations
end

describe ObjectWithParticipations do

  let(:object) do
    object = ObjectWithParticipations.new
    object.stubs(:participations).returns([])
    object
  end

  let(:contest) { stub(:id => 123) }

  describe '#participation_for?' do

    subject { object.participation_for?(contest) }

    it { should be_false }

    context 'when the object has participations' do

      before do
        object.stubs(:participations).returns([{'contest_id' => contest.id}])
      end

      it { should be_true }

    end

  end

end
