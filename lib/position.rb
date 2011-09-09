module Position

  def calculate_average_position
    participations_with_positions = participations.select { |p| p['position'] }
    return 0.0 if participations_with_positions.empty?
    participations_with_positions.inject(0) { |sum, p| sum + p['position'] } / participations_with_positions.length.to_f
  end

end
