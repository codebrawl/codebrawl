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

  def calculate_average_score
    participations.map { |p| p['score'] }.inject(:+) / participations.length
  end

  def calculate_average_score!
    update_attribute(:average_score, calculate_average_score)
  end

  def voted_entries(contest)
    contest.entries.select { |e| e.votes_from?(self) }
  end

  def participation_for?(contest)
    participations.map {|p| p['contest_id'] }.include? contest.id
  end

end
