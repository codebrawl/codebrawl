class User
  include Mongoid::Document

  field 'login', :type => String
  field 'github_id', :type => Integer

  validates :login, :presence => true
end
