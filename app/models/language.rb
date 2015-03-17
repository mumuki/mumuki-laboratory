require 'rest_client'

class Language < ActiveRecord::Base
  include WithMarkup

  validates_presence_of :name, :test_runner_url, :extension, :image_url

  markup_on :test_syntax_hint

  def run_tests!(test, content)
    response = JSON.parse RestClient.post("#{test_runner_url}/test", {content: content, test: test}.to_json)
    [response['out'], response['exit']]
  rescue Exception => e
    [e.message, :failed]
  end

  def to_s
    name
  end
end
