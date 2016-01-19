require_relative './seeds/book_builder'

if Apartment::Tenant.on? 'public'

  puts 'Seeding global'
  require_relative './seeds/languages'
  require_relative './seeds/guides'

  Book.find_or_create_by(name: 'central') do |it|
    it.locale = 'es'
  end.switch!

elsif Apartment::Tenant.on? 'central'

  require_relative './seeds/central'

end



