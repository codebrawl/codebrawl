require 'spec_helper'

describe Contest do

  context 'fabrication' do

    it { Fabricate(:contest).should be_valid }

  end

  context '.not_open' do

    before do
      @open = Fabricate(:contest, :starting_on => Date.yesterday.to_time)
      @voting = Fabricate(:contest, :voting_on => Date.yesterday.to_time)
      @finished = Fabricate(:contest, :closing_on => Date.yesterday.to_time)
    end

    subject { Contest.not_open }

    it { should include @finished }

    it { should include @voting }

    it { should_not include @open }

  end

  context '#save!' do

    context 'when keeping all fields empty' do

      it { should have(1).error_on(:name) }

      it { should have(1).error_on(:description) }

      it { should have(1).error_on(:starting_on) }

      it { should have(1).error_on(:user) }
      
      it { should have(1).error_on(:tagline ) }

    end

    context 'when creating a valid contest' do
      around { |example| Timecop.travel(Time.parse('May 23 2011 10:00 UTC')) { example.run } }
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

  end

  context '#entries' do

    it 'should have a list of entries' do
      entries = [Fabricate.build(:entry)]
      Fabricate(:contest, :entries => entries).entries.should == entries
    end

  end

  context '#user' do

    it 'should have a user' do
      user = Fabricate.build(:user)
      Fabricate.build(:contest, :user => user).user.should == user
    end

  end

  context '#pending?' do

    before { @contest = Fabricate(:contest) }

    context 'when the contest is pending for entries' do

      subject do
        @contest.stubs(:state).returns('pending')
        @contest.pending?
      end

      it { should be_true }

    end

    context 'when the contest is not pending' do

      subject do
        @contest.stubs(:state).returns('notpending')
        @contest.pending?
      end

      it { should be_false }

    end

  end

  context '#open?' do

    before { @contest = Fabricate(:contest) }

    context 'when the contest is open for entries' do

      subject do
        @contest.stubs(:state).returns('open')
        @contest.open?
      end

      it { should be_true }

    end

    context 'when the contest is not open for entries' do

      subject do
        @contest.stubs(:state).returns('notopen')
        @contest.open?
      end

      it { should be_false }

    end

  end

  context '#voting?' do

    before { @contest = Fabricate(:contest) }

    context 'when the contest is open for voting' do

      subject do
        @contest.stubs(:state).returns('voting')
        @contest.voting?
      end

      it { should be_true }

    end

    context 'when the contest is not open for voting' do

      subject do
        @contest.stubs(:state).returns('notvoting')
        @contest.voting?
      end

      it { should be_false }

    end

  end

  context '#finished?' do

    before { @contest = Fabricate(:contest) }

    context 'when the contest is finished' do

      subject do
        @contest.stubs(:state).returns('finished')
        @contest.finished?
      end

      it { should be_true }

    end

    context 'when the contest is not finished' do

      subject do
        @contest.stubs(:state).returns('notfinished')
        @contest.finished?
      end

      it { should be_false }

    end

  end

  context '#starting_at' do
    around { |example| Timecop.freeze { example.run } }

    subject do
      @contest = Fabricate(:contest, :starting_on => Date.parse('Jun 5 2011').to_time)
      @contest.starting_at
    end

    it { should == Time.parse('Jun 5 2011 12:00 UTC') }
    # TODO: Find out why it's 12:00 everywhere, except on production, where it's 14:00

  end

  context '#voting_at' do
    around { |example| Timecop.freeze { example.run } }

    subject do
      @contest = Fabricate(:contest, :voting_on => Date.parse('Jun 5 2011').to_time)
      @contest.voting_at
    end

    it { should == Time.parse('Jun 5 2011 13  12:00 UTC') }
    # TODO: Find out why it's 12:00 everywhere, except on production, where it's 14:00

  end

  context '#closing_at' do
    around { |example| Timecop.freeze { example.run } }

    subject do
      @contest = Fabricate(:contest, :voting_on => Date.parse('Jun 5 2011').to_time)
      @contest.voting_at
    end

    it { should == Time.parse('Jun 5 2011 12:00 UTC') }
    # TODO: Find out why it's 12:00 everywhere, except on production, where it's 14:00

  end

  context '#next_state_at' do

    before { @contest = Fabricate(:contest) }

    context 'when the contest is open' do
      before { @contest.stubs(:state).returns('open') }
      subject { @contest.next_state_at }

      it { should == @contest.voting_at }
    end

    context 'when the contest is open for voting' do
      before { @contest.stubs(:state).returns('voting') }
      subject { @contest.next_state_at }

      it { should == @contest.closing_at }
    end

    context 'when the contest is finished' do
      before { @contest.stubs(:state).returns('finished') }
      subject { @contest.next_state_at }

      it { should be_nil }
    end

  end

  context '#get_entry_files' do

    before do
      @contest = Fabricate(:contest, :entries => [Fabricate(:entry)] * 3)
      Entry.any_instance.stubs(:get_files_from_gist).returns({'file*txt' => {}})
      @contest.get_entry_files
    end

    it 'should the "file" attribute for every contest' do
      @contest.entries.each do |entry|
        entry.read_attribute(:files).should == {'file*txt' => {}}
      end
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

end
