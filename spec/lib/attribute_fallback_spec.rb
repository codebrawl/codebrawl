require 'spec_config'
require File.expand_path('lib/attribute_fallback')

class ObjectWithAttributeFallback
  extend AttributeFallback

  fallback :one, :two
end

describe AttributeFallback do

  let(:object) { ObjectWithAttributeFallback.new }

  subject { object.one }

  context 'when both attributes are set' do

    before { object.stubs(:read_attribute).returns(1,2) }

    it { should == 1 }

  end

  context 'when only the fallback is set' do

    before { object.stubs(:read_attribute).returns(nil,2) }

    it { should == 2 }

  end
end

