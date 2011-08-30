module Points

  def calculate_points
    participations.inject(0) { |sum, p| sum + p['points'] }
  end

  def calculate_average_points
    return 0.0 if participations.empty?
    calculate_points.to_f / participations.length
  end

end
