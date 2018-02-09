require_relative './seeds/import'

require_relative './seeds/languages'
import_resource! :guide
import_resource! :topic
import_resource! :books

require_relative './seeds/organizations'
require_relative './seeds/users'



