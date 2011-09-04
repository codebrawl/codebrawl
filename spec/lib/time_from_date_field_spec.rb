require 'spec_config'
require File.expand_path('lib/time_from_date_field')

class ObjectWithDates

  def anything_on
    Date.parse('Jun 5 2011')
  end

  include TimeFromDateField
end

describe TimeFromDateField do

  describe '#*_at' do

    subject { ObjectWithDates.new.anything_at }

    it 'should return the date as a time, at 14:00 UTC' do
      should == Time.parse('Jun 5 2011 14:00:00 UTC')
    end

  end

end
