require 'spec_config'
require File.expand_path('lib/bang')

class ObjectWithBang
  extend Bang
end

describe Bang do

  let(:object) do
    object = ObjectWithBang.new
    object.stubs(:attribute).returns(1)
    object.stubs(:get_attribute).returns(2)
    object
  end

  context 'with one banged attribute' do

    before { ObjectWithBang.send(:bang, :attribute) }

    it 'should save the attribute value' do
      object.expects(:update_attribute).with(:attribute, 1)
      object.attribute!
    end

  end

  context 'when the attribute and method names differ' do

    before { ObjectWithBang.send(:bang, :get_attribute => :attribute) }

    it 'should save the attribute value' do
      object.expects(:update_attribute).with(:attribute, 2)
      object.get_attribute!
    end

  end

end
