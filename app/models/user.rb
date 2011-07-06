class User
  include Mongoid::Document
  include Gravtastic

  field 'login', :type => String
  field 'email', :type => String
  field 'name', :type => String
  field 'github_id', :type => Integer
  field 'participations', :type => Array, :default => []
  field 'points', :type => Integer

  validates :login, :presence => true

  has_gravatar

  alias_method :to_param, :login

  def calculate_points
    participations.inspect
    participations.map do |participation|
      participation['points']
    end.inject { |a,b| a + b }
  end

  def calculate_points!
    update_attribute(:points, calculate_points)
  end

end
