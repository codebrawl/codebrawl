atom_feed do |feed|
  feed.title("Codebrawl")
  feed.updated(@contests.first.starting_on)

  for contest in @contests
    # next if contest.updated_at.blank?
    feed.entry(contest) do |entry|
      entry.title(contest.name)
      entry.content(contest.description, :type => 'html')
      # entry.updated(contest.updated_at.strftime("%Y-%m-dT%H:%M:%SZ"))
      entry.author do |author|
        author.name(contest.user.name)
      end
    end
  end
end
