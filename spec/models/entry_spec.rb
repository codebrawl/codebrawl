require 'spec_helper'

describe Entry do

  context 'fabrication' do

    it { Fabricate(:entry).should be_valid }

  end

  context '#save!' do

    context 'when keeping all fields empty' do

      it { should have(1).error_on(:user) }

      it { should have(1).error_on(:gist_id) }

    end

    context 'when filling in an invalid gist id' do

      around { |example| VCR.use_cassette('404_gist'){ example.run } }

      subject { Fabricate.build(:entry, :gist_id => 'omgfake') }

      it { should have(1).error_on(:gist_id) }

    end

    context 'when filling in an id of a gist that does not belong to the user' do

      around { |example| VCR.use_cassette('gist_with_files'){ example.run } }

      subject { Fabricate.build(:entry, :gist_id => '72a0a6a9aa63d1eb64d6') }

      it { should have(1).error_on(:gist_id) }

    end

  end

  context '#contest' do

    it 'should have a contest' do
      contest = Fabricate.build(:contest)
      Fabricate.build(:entry, :contest => contest).contest.should == contest
    end

  end

  context '#user' do

    it 'should have a user' do
      user = Fabricate.build(:user)
      Fabricate.build(:entry, :user => user).user.should == user
    end

  end

  context '#votes' do

    it 'should have a list of votes' do
      votes = [Fabricate.build(:user)]
      Fabricate.build(:entry, :votes => votes).votes.should == votes
    end

  end

  context '.save!' do

    context 'when keeping all fields empty' do

      it { should have(1).error_on(:user) }

    end

  end

  context '#score' do

    context 'when the score attribute is set' do

      subject { Fabricate(:entry, :score => 4.3).score }

      it { should == 4.3 }

    end

    context 'when not having a score attribute' do

      subject do
        @entry = Fabricate(:entry)
        @entry.score
      end

      it { should == 0.0 }

      it { should == @entry.read_attribute(:score) }

      context 'when having some votes' do
        subject do
          @entry = Fabricate(
            :entry,
            :votes => [
              Fabricate.build(:vote, :score => 2),
              Fabricate.build(:vote, :score => 4),
              Fabricate.build(:vote, :score => 1)
            ]
          )
          @entry.score
        end

        it { should == 2.3333333333333335 }

        it { should == @entry.read_attribute(:score) }

      end

    end

  end

  context '#files' do

    context 'when the files attribute is set' do
      subject do
        Fabricate(:entry, :files => {'1.txt' => {}}).files
      end

      it { should == {'1.txt' => {}} }
    end

    context 'when having a gist_id attribute' do
      subject do
        VCR.use_cassette('gist_with_files') do
          @entry = Fabricate(
            :entry,
            :user => Fabricate(:user, :github_id => '43621'),
            :gist_id => '72a0a6a9aa63d1eb64d6'
          )
          @entry.files
        end
      end

      it 'should get the gist contents from github' do
        should == {
          "2.txt" => {
            "content" => "2",
            "raw_url" => "https://gist.github.com/raw/72a0a6a9aa63d1eb64d6/d8263ee9860594d2806b0dfd1bfd17528b0ba2a4/2.txt",
            "size" => 1,
            "filename" => "2.txt"
          },
          "3.txt" => {
            "content" => "3",
            "raw_url" => "https://gist.github.com/raw/72a0a6a9aa63d1eb64d6/e440e5c842586965a7fb77deda2eca68612b1f53/3.txt",
            "size" => 1,
            "filename" => "3.txt"
          },
          "1.txt" => {
            "content" => "1",
            "raw_url" => "https://gist.github.com/raw/72a0a6a9aa63d1eb64d6/56a6051ca2b02b04ef92d5150c9ef600403cb1de/1.txt",
            "size" => 1,
            "filename" => "1.txt"
          }
        }
      end

      it { should == @entry.read_attribute(:files) }
    end

  end

end
