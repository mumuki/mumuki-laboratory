require_relative './seeds/book_builder'
require_relative './seeds/import'

if Apartment::Tenant.on? 'public'

  puts 'Seeding global'
  require_relative './seeds/languages'
  import_resource! :guide
  import_resource! :topic
  import_resource! :books
  require_relative './seeds/organizations'
end



