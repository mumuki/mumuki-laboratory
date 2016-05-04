require 'mumukit/bridge'

def import_resource!(resource)
  Mumukit::Bridge::Bibliotheca.new.send(resource.to_s.pluralize).each do |r|
    slug = r['slug']
    clazz = resource.to_s.classify.constantize
    puts "Importing #{resource} #{slug}"
    begin
      clazz.find_or_create_by!(slug: slug).import!
    rescue => e
      puts "Ignoring #{slug} because of import error #{e}"
    end
  end
end
