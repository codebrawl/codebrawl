module Points

  def calculate_points
    participations.map { |p| p['points'] }.inject(&:+) || 0
  end

  def calculate_average_points
    return 0.0 if participations.empty?
    calculate_points.to_f / participations.length
  end

end
