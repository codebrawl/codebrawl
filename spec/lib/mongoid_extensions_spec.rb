require 'spec_helper'
require File.expand_path('lib/mongoid_extensions.rb')

class ExtendedDocument
  include Mongoid::Document
end

describe MongoidExtensions do

  let(:object) do
    object = ExtendedDocument.new
    object.stubs(:id).returns(123)
    object
  end

  describe '#not_found' do

    subject { object.not_found }

    it 'should raise a DocumentNotFound error' do
      expect { subject }.to raise_error Mongoid::Errors::DocumentNotFound
    end

  end

end
