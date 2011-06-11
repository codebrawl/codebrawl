require 'pygments'
require 'kramdown'
require 'RedCloth'

class Gust

  def self.parse(code, options = {})

    output = case options[:filename]
      when /.*\.textile$/ then RedCloth.new(code).to_html
      when /.*\.md$/, /.*\.markdown$/ then Kramdown::Document.new(code).to_html
      else return Pygments.highlight(code, options) rescue code
    end

    "<div class=\"markup\">#{output}</div>"

  end

end
