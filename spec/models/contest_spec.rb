require 'spec_helper'

describe Contest do

  context '.not_open' do

    subject { Contest.not_open }
    %w{ open voting finished }.each do |state|
      let(state) { Fabricate("contest_#{state}".to_sym) }
    end

    it { should include finished }

    it { should include voting }

    it { should_not include open }

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

end
