module Mongoid::Document

  def has_a_presence_error_on?(field)
    valid?
    errors[field].include? 'can\'t be blank'
  end

  def open?
    state == 'open'
  end

  def has_a_duration_of?(duration)
    self.duration == duration
  end

end
