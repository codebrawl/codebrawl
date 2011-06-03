require "#{Rails.root}/spec/support/blueprints"
[Contest, User].each { |model| model.delete_all }

3.times do |i|
  Contest.make(
    :starting_on => (i.weeks + 1.day).ago.to_time,
    :entries => [Entry.make, Entry.make, Entry.make]
  )
end
