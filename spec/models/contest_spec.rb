require 'spec_helper'

describe Contest do

  it { should validate_presence_of(:name) }

  it { should validate_presence_of(:description) }

  it { should validate_presence_of(:starting_on) }

  it { should validate_presence_of(:user) }

  it { should validate_presence_of(:tagline) }

  it { should ensure_length_of(:tagline).is_at_least(50) }

  context '.not_open' do

    subject { Contest.not_open }
    %w{ open voting finished }.each do |state|
      let(state) { Fabricate("contest_#{state}".to_sym) }
    end

    it { should include finished }

    it { should include voting }

    it { should_not include open }

  end

  context '.by_slug' do

    it 'should raise a DocumentNotFound error if the contest does not exist' do
      expect {
        Contest.by_slug('slug')
      }.to raise_error(Mongoid::Errors::DocumentNotFound)
    end

    context 'when the contest exists' do

      subject { Contest.by_slug('slug') }

      let(:contest) { Fabricate(:contest, :name => 'slug') }

      before { contest }

      it 'should return the contest' do
        should == contest
      end

    end

  end

  context '#save!' do

    around do |example|
      Timecop.travel(Time.parse('May 23 2011 10:00 UTC')) { example.run }
    end

    subject { Fabricate(:contest) }

    it { should be_pending }

    it { should have_a_starting_date_of Date.parse('May 23 2011') }

    it { should have_a_voting_date_of Date.parse('May 30 2011') }

    it { should have_a_closing_date_of Date.parse('June 6 2011') }

    context 'after 4PM, UTC' do

      around { |example| Timecop.travel(Time.parse('May 23 2011 18:00 UTC')) { example.run } }

      it { should be_open }

    end

    context 'after seven days, before 4PM, UTC' do

      around { |example| Timecop.travel(Time.parse('May 30 2011 11:00 UTC')) { example.run } }

      it { should be_open }

    end

    context 'after seven days, after 4PM, UTC' do

      around { |example| Timecop.travel(Time.parse('May 30 2011 17:00 UTC')) { example.run } }

      it { should be_voting }

    end

    context 'after fourteen days, before 4PM, UTC' do

      around { |example| Timecop.travel(Time.parse('June 6 2011 11:00 UTC')) { example.run } }

      it { should be_voting }

    end

    context 'after fourteen days, after 4PM, UTC' do

      around { |example| Timecop.travel(Time.parse('June 6 2011 17:00 UTC')) { example.run } }

      it { should be_finished }

    end

  end

  context '#add_participations_to_contestants!' do

    context 'when having five entries' do

      before do
        @scores = (1..5).to_a.reverse

        @contest = Fabricate(
          :contest,
          :entries => @scores.map { |score| Fabricate(:entry, :score => score) }
        )
        @contest.add_participations_to_contestants!
      end

      it 'should create a participation for every contestant' do
        @contest.entries.each do |entry|
          entry.user.reload.participations.should have(1).item
        end
      end

      it 'should set the contest ids' do
        @contest.entries.each do |entry|
          entry.user.reload.participations.first['contest_id'].should == @contest.id
        end
      end

      it 'should set the contest names' do
        @contest.entries.each do |entry|
          entry.user.reload.participations.first['contest_name'].should == @contest.name
        end
      end

      it 'should set the contest slugs' do
        @contest.entries.each do |entry|
          entry.user.reload.participations.first['contest_slug'].should == @contest.slug
        end
      end

      it 'should set the contest scores' do
        @scores.each_with_index do |score, index|
          @contest.entries[index].user.reload.participations.first['score'].should == score
        end
      end

      it 'should set the contest points' do
        [50, 40, 30, 20, 10].each_with_index do |points, index|
          @contest.entries[index].user.reload.participations.first['points'].should == points
        end
      end

      it 'should set the contest positions' do
        5.times do |index|
          @contest.entries[index].user.reload.participations.first['position'].should == index + 1
        end
      end

      context 'when already having a participation for this contest' do

        before do
          @contest.add_participations_to_contestants!
        end

        it 'should not add another participation' do
          @contest.entries.each do |entry|
            entry.user.reload.participations.should have(1).item
          end
        end

      end

    end

    context 'when having eleven entries' do

      before do
        @scores = [5.0, 4.5, 4.0, 3.5, 3.0, 2.5, 2.0, 1.5, 1.0, 0.5, 0.0]

        @contest = Fabricate(
          :contest,
          :entries => @scores.map { |score| Fabricate(:entry, :score => score) }
        )
        @contest.add_participations_to_contestants!
      end

      it 'should set the contest points' do
        [100, 90, 80, 70, 60, 50, 40, 30, 20, 10, 10].each_with_index do |points, index|
          @contest.entries[index].user.reload.participations.first['points'].should == points
        end
      end

    end

  end

  describe '#has_entry_from?' do

    before do
      @contest = Fabricate(:contest)
      @user = Fabricate(:user)
    end

    subject { @contest.has_entry_from?(@user) }

    context 'when the user is a participant' do
      before { @contest.entries.create(:user => @user) }
      it { should be_true }
    end

    context 'when the user is not a participant' do
      it { should be_false }
    end

  end

  describe '#voted_entries' do

    let(:user) { Fabricate.build(:user) }
    let(:entry) { Fabricate.build(:entry) }
    let(:contest) { entry.contest }

    before { entry.stubs(:votes_from?).with(user).returns(true) }

    subject { contest.voted_entries(user) }

    it 'returns entries the user has voted on' do
      should == [entry]
    end

  end

end
