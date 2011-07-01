class User
  include Mongoid::Document
  include Gravtastic

  field 'login', :type => String
  field 'email', :type => String
  field 'name', :type => String
  field 'github_id', :type => Integer
  field 'admin', :type => Boolean, :default => false
  has_many :contests

  validates :login, :presence => true

  has_gravatar

  attr_accessible :login, :email, :name, :github_id

  alias_method :to_param, :login

  def created?(object)
    object.respond_to?(:user) && object.user == self
  end
end
