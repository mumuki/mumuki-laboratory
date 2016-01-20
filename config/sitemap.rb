SitemapGenerator::Sitemap.default_host = 'http://mumuki.io'
SitemapGenerator::Sitemap.sitemaps_path = 'sitemaps/'

Book.central.switch!

SitemapGenerator::Sitemap.create do
  add '/', changefreq: 'daily', priority: 0.9
  add '/chapters', changefreq: 'daily', priority: 0.8
  add '/exercises', changefreq: 'daily', priority: 0.6
  add '/guides', changefreq: 'daily', priority: 0.7
  add '/users', changefreq: 'daily', priority: 0.3

  Chapter.all.each do |c|
    add "/chapters/#{c.to_param}", changefreq: 'daily', priority: 0.55
  end

  Exercise.all.each do |e|
    add "/exercises/#{e.to_param}", changefreq: 'daily', priority: 0.55
  end

  Guide.all.each do |g|
    add "/guides/#{g.to_param}", changefreq: 'daily', priority: 0.55
  end

  User.all.each do |u|
    add "/users/#{u.to_param}", changefreq: 'daily', priority: 0.2
  end
end


