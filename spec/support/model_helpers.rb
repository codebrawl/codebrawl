module Mongoid::Document

  def has_a_starting_date_of?(date)
    starting_on == date
  end

  def has_a_voting_date_of?(date)
    voting_on == date
  end

  def has_a_closing_date_of?(date)
    closing_on == date
  end

end
