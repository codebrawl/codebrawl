atom_feed do |feed|
  feed.title("Codebrawl")
  feed.updated(@contests.first.starting_on)

  @contests.each do |contest|
    feed.entry(contest) do |entry|
      entry.title(contest.name)
      entry.content(Kramdown::Document.new(contest.description).to_html, :type => 'html')
      entry.author do |author|
        author.name(contest.user.name)
      end
    end
  end
end
