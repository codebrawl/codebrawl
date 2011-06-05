require 'spec_helper'

describe Contest do

  context '.make' do

    it { Contest.make.should be_valid }

  end

  context '#save!' do

    context 'when keeping all fields empty' do

      it { should have_a_presence_error_on(:name) }

      it { should have_a_presence_error_on(:description) }

      it { should have_a_presence_error_on(:starting_on) }

    end

    context 'when creating a valid contest' do
      around { |example| Timecop.travel(Time.parse('May 23 2011 10:00 UTC')) { example.run } }
      subject { Contest.make }

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

        it { should be_closed }

      end

    end

  end

  context '#entries' do

    it 'should have a list of entries' do
      entries = [Entry.make]
      Contest.make(:entries => entries).entries.should == entries
    end

  end

  context '#pending?' do

    before { @contest = Contest.make }

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

    before { @contest = Contest.make }

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

    before { @contest = Contest.make }

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

  context '#closed?' do

    before { @contest = Contest.make }

    context 'when the contest is closed' do

      subject do
        @contest.stubs(:state).returns('closed')
        @contest.closed?
      end

      it { should be_true }

    end

    context 'when the contest is not closed' do

      subject do
        @contest.stubs(:state).returns('notclosed')
        @contest.closed?
      end

      it { should be_false }

    end

  end

  context '#starting_at' do
    around { |example| Timecop.freeze { example.run } }

    subject do
      @contest = Contest.make(:starting_on => Date.parse('Jun 5 2011').to_time)
      @contest.starting_at
    end

    it { should == Time.parse('Jun 5 2011 14:00 UTC') }

  end

  context '#voting_at' do
    around { |example| Timecop.freeze { example.run } }

    subject do
      @contest = Contest.make(:voting_on => Date.parse('Jun 5 2011').to_time)
      @contest.voting_at
    end

    it { should == Time.parse('Jun 5 2011 14:00 UTC') }

  end

  context '#closing_at' do
    around { |example| Timecop.freeze { example.run } }

    subject do
      @contest = Contest.make(:voting_on => Date.parse('Jun 5 2011').to_time)
      @contest.voting_at
    end

    it { should == Time.parse('Jun 5 2011 14:00 UTC') }

  end

end
