xml.instruct!
xml.urlset(:xmlns => 'http://www.sitemaps.org/schemas/sitemap/0.9') do
  @data.each do |url|
    xml.url do
      xml.loc url[:loc]
      xml.lastmod url[:lastmod]
      xml.changefreq url[:changefreq]
      xml.priority url[:priority]
    end
  end
end
