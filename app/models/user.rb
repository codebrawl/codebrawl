class User
  include Mongoid::Document
  include Gravtastic

  field 'login', :type => String
  field 'email', :type => String
  field 'github_id', :type => Integer

  validates :login, :presence => true

  has_gravatar
end
