# Set the host name for URL creation
SitemapGenerator::Sitemap.default_host = 'http://mumuki.io'

SitemapGenerator::Sitemap.create do
  add '/en', :changefreq => 'daily', :priority => 0.9
  add '/es', :changefreq => 'daily', :priority => 0.9

  add '/es/exercises', :changefreq => 'daily', :priority => 0.6
  add '/en/exercises', :changefreq => 'daily', :priority => 0.6

  add '/es/guides', :changefreq => 'daily', :priority => 0.7
  add '/en/guides', :changefreq => 'daily', :priority => 0.7

  add '/es/users', :changefreq => 'daily', :priority => 0.1
  add '/en/users', :changefreq => 'daily', :priority => 0.1

  Exercise.all.pluck(:id).each do |id|
    add "/es/exercises/#{id}", :changefreq => 'daily', :priority => 0.5
    add "/es/exercises/#{id}", :changefreq => 'daily', :priority => 0.5
  end

  Guide.all.pluck(:id).each do |id|
    add "/es/guides/#{id}", :changefreq => 'daily', :priority => 0.3
    add "/es/guides/#{id}", :changefreq => 'daily', :priority => 0.3
  end

  User.all.pluck(:id).each do |id|
    add "/es/users/#{id}", :changefreq => 'daily', :priority => 0.2
    add "/es/users/#{id}", :changefreq => 'daily', :priority => 0.2
  end





  # Put links creation logic here.
  #
  # The root path '/' and sitemap index file are added automatically for you.
  # Links are added to the Sitemap in the order they are specified.
  #
  # Usage: add(path, options={})
  #        (default options are used if you don't specify)
  #
  # Defaults: :priority => 0.5, :changefreq => 'weekly',
  #           :lastmod => Time.now, :host => default_host
  #
  # Examples:
  #
  # Add '/articles'
  #
  #   add articles_path, :priority => 0.7, :changefreq => 'daily'
  #
  # Add all articles:
  #
  #   Article.find_each do |article|
  #     add article_path(article), :lastmod => article.updated_at
  #   end
end
