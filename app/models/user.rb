require 'points'
require 'scores'
require 'participations'

class User
  include Mongoid::Document
  include Mongoid::Timestamps
  include Gravtastic
  include Participations
  include Points
  include Scores

  field 'login', :type => String
  field 'email', :type => String
  field 'token', :type => String
  field 'name', :type => String
  field 'github_id', :type => Integer
  field 'participations', :type => Array, :default => []
  field 'points', :type => Integer, :default => 0
  field 'average_score', :type => Float, :default => 0.0
  field 'urls', :type => Hash, :default => {}
  field 'contributions', :type => Integer

  validates :login, :presence => true

  has_gravatar

  alias_method :to_param, :login

  def best_name
    name || login
  end

  def calculate_points!
    update_attribute(:points, calculate_points)
  end

  def calculate_average_score!
    update_attribute(:average_score, calculate_average_score)
  end

  def calculate_average_position
    participations_with_positions = participations.select { |p| p['position'] }
    return 0.0 if participations_with_positions.empty?
    participations_with_positions.inject(0) { |sum, p| sum + p['position'] } / participations_with_positions.length.to_f
  end

  def voted_entries(contest)
    contest.entries.select { |e| e.votes_from?(self) }
  end

end
