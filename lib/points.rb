require File.expand_path('lib/array_average')

module Points

  def calculate_points
    participations.inject(0) { |sum, p| sum + p['points'] }
  end

  def calculate_average_points
    participations.map { |p| p['points'] }.average
  end

end
