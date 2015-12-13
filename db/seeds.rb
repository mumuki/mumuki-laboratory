if Tenant.on_public?
  puts 'Seeding global'
  require_relative './seeds/languages'
  require_relative './seeds/guides'

  Tenant.create!(name: 'central', locale: 'es').switch!
else
  Chapter.create!(name: 'Programación Funcional',
                  locale: :es,
                  description: 'Programación Funcional',
                  image_url: 'http://mumuki.io/favicon').rebuild!(Guide.all)
end



