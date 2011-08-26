module Scores

  def calculate_average_score
    return 0.0 if participations.empty?
    participations.map { |p| p['score'] }.inject(:+) / participations.length
  end


end
