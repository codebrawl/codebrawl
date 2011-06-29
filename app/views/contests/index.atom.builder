atom_feed do |feed|
  feed.title("Codebrawl")
  feed.updated(@contests.first.starting_on)

  @contests.each do |contest|
    feed.entry(contest) do |entry|
      entry.title(contest.name)
      entry.content(contest.description, :type => 'html')
      entry.author do |author|
        author.name(contest.user.name)
      end
    end
  end
end
