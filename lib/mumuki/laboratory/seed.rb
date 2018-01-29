require 'mumukit/bridge'

module Mumuki::Laboratory::Seed
  class << self
      def import_content!(resource)
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

      def import_contents!
        %w(guide topic book).each { |it| Mumuki::Laboratory::Seed.import_content!(it) }
      end

      def import_languages!
        (%W(http://gobstones.runners.mumuki.io) + Mumukit::Bridge::Thesaurus.new(Mumukit::Platform.config.thesaurus_url).runners).each do |url|
          puts "Importing Language #{url}"

          begin
            Language.find_or_initialize_by(runner_url: url).import!
          rescue => e
            puts "Ignoring Language #{url} because of import error #{e}"
          end
        end
      end

    end
end
