module Points

  def calculate_points
    participations.map { |p| p['points'] }.inject(&:+) || 0
  end

end
