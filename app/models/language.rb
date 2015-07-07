require 'mumukit/bridge'

class Language < ActiveRecord::Base
  include WithMarkup, WithCaseInsensitiveSearch

  enum output_content_type: [:plain, :html, :markdown]

  validates_presence_of :test_runner_url,
                        :extension, :image_url, :output_content_type

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  markup_on :test_syntax_hint

  def run_tests!(request)
    bridge.run_tests!(request)
  end

  def bridge
    Mumukit::Bridge::Bridge.new(test_runner_url)
  end

  def test_extension
    self[:test_extension] || extension
  end

  def highlight_mode
    self[:highlight_mode] || name
  end

  def output_content_type
    ContentType.for(self.class.output_content_types.key(self[:output_content_type]))
  end

  def to_s
    name
  end
end
