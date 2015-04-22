require 'rest_client'

class Language < ActiveRecord::Base
  include WithMarkup

  validates_presence_of :name, :test_runner_url, :extension, :image_url

  markup_on :test_syntax_hint

  before_save :downcase_name!

  def run_tests!(request)
    response = post_to_server(request)

    {result: response['out'],
     status: response['exit'],
     expectation_results: parse_expectation_results(response['expectationResults'] || [])}

  rescue Exception => e
    {result: e.message, status: :failed}
  end

  def parse_expectation_results(results)
    results.map do |it|
      {binding: it['expectation']['binding'],
       inspection: it['expectation']['inspection'],
       result: it['result'] ? :passed : :failed}
    end
  end

  def post_to_server(request)
    JSON.parse RestClient.post(
        "#{test_runner_url}/test",
        request.to_json,
        content_type: :json)
  end

  def downcase_name!
    self.name = name.downcase
  end

  def to_s
    name
  end
end
