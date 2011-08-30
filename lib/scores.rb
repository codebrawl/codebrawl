module Scores

  def calculate_average_score
    return 0.0 if participations.empty?
    participations.inject(0) { |sum, p| sum + p['score'] } / participations.length
  end


end
