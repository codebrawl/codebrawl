module ArrayAverage

  def average
    values = self.compact
    return 0 if values.empty?
    values.inject(&:+) / values.length.to_f
  end

end

Array.send(:include, ArrayAverage)
