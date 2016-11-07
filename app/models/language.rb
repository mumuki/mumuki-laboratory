require 'mumukit/bridge'

class Language < ActiveRecord::Base
  include WithCaseInsensitiveSearch

  enum output_content_type: [:plain, :html, :markdown]

  validates_presence_of :runner_url, :output_content_type

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  markdown_on :test_syntax_hint, :description

  delegate :run_tests!, :run_query!, to: :bridge

  def bridge
    Mumukit::Bridge::Runner.new(runner_url)
  end

  def highlight_mode
    self[:highlight_mode] || name
  end

  def output_content_type
    Mumukit::ContentType.for(self.class.output_content_types.key(self[:output_content_type]))
  end

  def to_s
    name
  end

  def self.for_name(name)
    find_by_ignore_case!(:name, name) if name
  end

  def import!
    import_from_json! Mumukit::Bridge::Runner.new(runner_url).info
  end

  def devicon
    name.downcase
  end

  def import_from_json!(json)
    raise 'Only devicons supported' if json.dig('language', 'icon', 'type') != 'devicon'

    assign_attributes name: json['name'],
                      highlight_mode: json.dig('language', 'ace_mode'),
                      visible_success_output: json.dig('language', 'graphic').present?,
                      prompt: (json.dig('language', 'prompt') || 'ム')  + ' ',
                      output_content_type: json['output_content_type'],
                      queriable: json.dig('features', 'query'),
                      stateful_console: json.dig('features', 'stateful').present?,
                      extension: json.dig('language','extension')
    save!
  end
end
