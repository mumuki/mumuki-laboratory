require 'mumukit/bridge'

Mumukit::Bridge::Bibliotheca.new.guides.each do |g|
  slug = g['slug']
  puts "Importing #{slug}"

  Guide.create!(slug: slug).import!
end
