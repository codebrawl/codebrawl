require "#{Rails.root}/spec/support/blueprints"
Contest.delete_all

3.times { Contest.make }
