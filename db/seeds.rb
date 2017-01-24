require_relative './seeds/import'

require_relative './seeds/languages'
import_resource! :guide
import_resource! :topic
import_resource! :books

Organization.find_or_create_by!(name: 'central') do |org|
  org.contact_email = 'issues@mumuki.org'
  org.book = Book.find_by!(slug: 'mumuki/mumuki-libro-programacion')
  org.private = false
  org.login_methods = Mumukit::Login::Settings.login_methods
end



