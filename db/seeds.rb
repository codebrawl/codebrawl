require "#{Rails.root}/spec/support/blueprints"
Contest.delete_all

3.times do |i|
  Contest.make(
    :starting_on => i.weeks.ago.to_time,
    :entries => [Entry.make] * 3
  )
end
