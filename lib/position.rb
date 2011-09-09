require File.expand_path('lib/array_average')

module Position

  def calculate_average_position
    participations.map { |p| p['position'] }.average
  end

end
