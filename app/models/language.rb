require 'mumukit/bridge'

class Language < ActiveRecord::Base
  include WithMarkup

  validates_presence_of :name, :test_runner_url, :extension, :image_url

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

  def to_s
    name
  end
end
