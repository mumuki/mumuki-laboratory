require_relative './seeds/book_builder'
require_relative './seeds/import'

require_relative './seeds/languages'
import_resource! :guide
import_resource! :topic
import_resource! :books

Organization.create! name: 'central',
                     contact_email: 'issues@mumuki.org',
                     book: Book.find_by(slug: 'mumuki/mumuki-libro-programacion')



