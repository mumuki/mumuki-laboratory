require 'rest_client'

class Language < ActiveRecord::Base
  include WithMarkup

  validates_presence_of :name, :test_runner_url, :extension, :image_url

  markup_on :test_syntax_hint

  def run_tests!(test, extra, content)
    raw_response = RestClient.post(
        "#{test_runner_url}/test",
        {test: test, extra: extra || '', content: content}.to_json,
        content_type: :json)
    response = JSON.parse raw_response
    [response['out'], response['exit']]
  rescue Exception => e
    [e.message, :failed]
  end

  def to_s
    name
  end
end
