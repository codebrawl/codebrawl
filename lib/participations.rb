module Participations
  def participation_for?(contest)
    participations.map {|p| p['contest_id'] }.include? contest.id
  end
end
