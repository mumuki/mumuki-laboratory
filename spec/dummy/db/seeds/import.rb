require 'mumukit/bridge'

def import_resource!(resource)
  Mumukit::Bridge::Bibliotheca.new(Mumukit::Platform.bibliotheca_api.url).send(resource.to_s.pluralize).each do |r|
    slug = r['slug']
    clazz = resource.to_s.classify.constantize
    puts "Importing #{resource} #{slug}"
    begin
      item = clazz.import!(slug)
    rescue => e
      puts "Ignoring #{slug} because of import error #{e}"
    end
  end
end
