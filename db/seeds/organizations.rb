Organization.find_or_create_by!(name: 'central') do |org|
  org.contact_email = 'issues@mumuki.org'
  org.units << Unit.new(book: Book.find_by!(slug: 'mumuki/mumuki-libro-programacion'))
  org.public = true
  org.login_methods = Mumukit::Login::Settings.login_methods
end
