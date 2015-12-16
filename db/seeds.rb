require_relative './seeds/book'

if Tenant.on_public?
  puts 'Seeding global'
  require_relative './seeds/languages'
  require_relative './seeds/guides'

  Tenant.create!(name: 'central', locale: 'es').switch!
elsif Tenant.on_central?
  require_relative './seeds/central'
end



