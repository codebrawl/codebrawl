class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravtastic

  field 'login', :type => String
  field 'email', :type => String
  field 'token', :type => String
  field 'name', :type => String
  field 'github_id', :type => Integer
  field 'participations', :type => Array, :default => []
  field 'points', :type => Integer
  field 'urls', :type => Hash, :default => {}

  validates :login, :presence => true

  has_gravatar

  alias_method :to_param, :login

  def calculate_points
    participations.map { |p| p['points'] }.inject(:+)
  end

  def calculate_points!
    update_attribute(:points, calculate_points)
  end

  def voted_entries(contest)
    contest.entries.select { |e| e.votes_from?(self) }
  end

  def average_score
    return 0.0 if participations.empty?
    sum = participations.map { |p| p['score'] }.inject(:+).to_f
    sum / participations.length
  end

end
