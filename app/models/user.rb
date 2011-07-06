class User
  include Mongoid::Document
  include Gravtastic

  field 'login', :type => String
  field 'email', :type => String
  field 'name', :type => String
  field 'github_id', :type => Integer
  field 'participations', :type => Array, :default => []

  validates :login, :presence => true

  has_gravatar

  alias_method :to_param, :login
end
