require 'spec_helper'

describe Comment do

  context '.make' do

    it { Comment.make.should be_valid }

  end

end
