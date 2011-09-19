require 'spec_config'
require 'active_model'
require 'rspec/rails/extensions'

require File.expand_path('app/validators/gist_validator')

class ObjectWithGist
  include ActiveModel::Validations
  validates_with GistValidator
end

describe GistValidator do

  before do
    Gist.stubs(:fetch).returns(
      Gist.new(200, '{"user": {"id": 12345}}')
    )
  end

  let(:object) do
    object = ObjectWithGist.new
    object.stubs(:gist_id).returns(12345)
    object.stubs(:user).returns(stub(:github_id => 12345))
    object
  end

  subject { object }

  context 'with a valid gist_id' do

    it { should be_valid }

  end

  context 'with a gist_id that does not exist' do

    before do
      Gist.stubs(:fetch).returns(Gist.new(404, '{}'))
      object.valid?
    end

    it { should have(1).error_on(:gist_id) }

    context 'the error' do

      subject { object.errors[:gist_id].first }

      it { should == 'does not exist' }

    end

  end

  context 'with an anonymous gist' do

    before do
      Gist.stubs(:fetch).returns(Gist.new(200, '{}'))
      object.valid?
    end

    it { should have(1).error_on(:gist_id) }

    context 'the error' do

      subject { object.errors[:gist_id].first }

      it { should == "can't be anonymous" }

    end

  end


  context 'with a gist that does not belong to the user' do

    before do
      Gist.stubs(:fetch).returns(Gist.new(200, '{"user": {"id": 54321}}'))
      object.valid?
    end

    it { should have(1).error_on(:gist_id) }

    context 'the error' do

      subject { object.errors[:gist_id].first }

      it { should == 'is not yours' }

    end

  end

end
