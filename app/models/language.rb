require 'mumukit/bridge'

class Language < ActiveRecord::Base
  include WithCaseInsensitiveSearch

  enum output_content_type: [:plain, :html, :markdown]

  validates_presence_of :runner_url, :output_content_type

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  markdown_on :description

  delegate :run_tests!, :run_query!, :run_try!, to: :bridge

  def bridge
    Mumukit::Bridge::Runner.new(runner_url)
  end

  def highlight_mode
    self[:highlight_mode] || name
  end

  def output_content_type
    Mumukit::ContentType.for(self[:output_content_type])
  end

  def to_s
    name
  end

  def self.for_name(name)
    find_by_ignore_case!(:name, name) if name
  end

  def import!
    import_from_json! Mumukit::Bridge::Runner.new(runner_url).importable_info
  end

  def devicon
    self[:devicon] || name.downcase
  end

  def import_from_json!(json)

    assign_attributes json.slice(:name,
                                 :comment_type,
                                 :output_content_type,
                                 :prompt,
                                 :extension,
                                 :highlight_mode,
                                 :visible_success_output,
                                 :devicon,
                                 :triable,
                                 :queriable,
                                 :stateful_console)
    save!
  end
end
