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
    Mumukit::Sync::Syncer.new(
      Mumukit::Sync::Store::Bibliotheca.new(
        Mumukit::Platform.bibliotheca_bridge)).import_all! /^#{MAIN_CONTENT_ORGANIZATIONS.join('|')}\/.*$/i
  end

  def self.import_languages!
    Mumukit::Sync::Syncer.new(
      Mumukit::Sync::Store::Thesaurus.new(
        Mumukit::Platform.thesaurus_bridge)).import_all!
  end
end
