require 'mumukit/bridge'

class Language < ActiveRecord::Base
  include WithCaseInsensitiveSearch

  enum output_content_type: [:plain, :html, :markdown]

  validates_presence_of :test_runner_url, :devicon, :output_content_type

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  markdown_on :test_syntax_hint, :description

  delegate :run_tests!, :run_query!, to: :bridge

  def bridge
    Mumukit::Bridge::Runner.new(test_runner_url)
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
end
