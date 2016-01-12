require 'mumukit/bridge'

Mumukit::Bridge::Bibliotheca.new.guides.each do |g|
  slug = g['slug']
  puts "Importing #{slug}"


  begin
    Guide.find_or_create_by!(slug: slug).import!
  rescue => e
    puts "Ignoring #{slug} because of import error #{e}"
  end
end
