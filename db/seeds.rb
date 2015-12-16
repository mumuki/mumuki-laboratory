require_relative './seeds/book'

if Tenant.on_public?
  puts 'Seeding global'
  require_relative './seeds/languages'
  require_relative './seeds/guides'

  Tenant.find_or_create_by(name: 'central') do |it|
    it.locale = 'es'
  end.switch!
elsif Tenant.on_central?
  require_relative './seeds/central'
end



