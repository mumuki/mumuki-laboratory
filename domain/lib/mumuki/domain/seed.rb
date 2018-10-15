require 'mumukit/bridge'

module Mumuki::Domain::Seed
  # Those are organizations that provide content
  # that was actually curated by the Mumuki Project and
  # as such must be supported by each platform release
  MAIN_CONTENT_ORGANIZATIONS = %w(
    mumuki
    mumukiproject
    sagrado-corazon-alcal
    pdep-utn
    smartedu-mumuki
    10pines-mumuki
    arquitecturas-concurrentes
    flbulgarelli
  )

  def self.import_main_contents!
    import_contents! /^#{MAIN_CONTENT_ORGANIZATIONS.join('|')}\/.*$/i
  end

  def self.import_contents!(slug_regex = /.*/)
    Mumukit::Platform.bibliotheca_bridge.import_contents!(slug_regex) do |resource_type, slug|
      resource_type.classify.constantize.import!(slug)
    end
  end

  def self.import_languages!
    Mumukit::Platform.thesaurus_bridge.import_languages! do |runner_url|
      Language.find_or_initialize_by(runner_url: runner_url).import!
    end
  end
end
