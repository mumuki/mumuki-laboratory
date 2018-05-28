require 'mumukit/bridge'

module Mumuki::Laboratory::Seed
  def self.import_contents!
    Mumukit::Platform.bibliotheca_bridge.import_contents! do |resource_type, slug|
      resource_type.classify.constantize.import!(slug)
    end
  end

  def self.import_languages!
    Mumukit::Platform.thesaurus_bridge.import_languages! do |runner_url|
      Language.find_or_initialize_by(runner_url: runner_url).import!
    end
  end
end
