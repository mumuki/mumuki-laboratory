require 'mumukit/bridge'

class Language < ActiveRecord::Base
  include WithMarkup

  enum output_content_type: [:plain, :html, :markdown]

  validates_presence_of :name, :test_runner_url,
                        :extension, :image_url, :output_content_type

  markup_on :test_syntax_hint

  before_save :downcase_name!

  def run_tests!(request)
    bridge.run_tests!(request)
  end

  def downcase_name!
    self.name = name.downcase
  end

  def bridge
    Mumukit::Bridge::Bridge.new(test_runner_url)
  end

  def test_extension
    self[:test_extension] || extension
  end

  def to_s
    name
  end

  def output_to_html(content)
    ContentType.for(output_content_type).to_html(content)
  end
end
