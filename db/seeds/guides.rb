require 'mumukit/bridge'

Mumukit::Bridge::Bibliotheca.new.guides.each do |g|
  slug = g['slug']
  puts "Importing #{slug}"

  Guide.find_or_create_by!(slug: slug).import!
end
