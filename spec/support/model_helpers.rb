module Mongoid::Document

  def has_a_presence_error_on?(field)
    valid?
    errors[field].include? 'can\'t be blank'
  end

end