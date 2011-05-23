module Mongoid::Document

  def has_a_presence_error_on?(field)
    valid?
    errors[field].include? 'can\'t be blank'
  end

  def open?
    state == 'open'
  end

  def has_a_voting_date_of?(date)
    self.voting_on == date
  end

  def has_a_closing_date_of?(date)
    self.closing_on == date
  end

end
