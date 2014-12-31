require 'rest_client'

class Language < ActiveRecord::Base
  belongs_to :author, class_name: 'User'

  validates_presence_of :name, :test_runner_url, :extension, :image_url

  def run_tests!(test, content)
    response = JSON.parse RestClient.post("#{test_runner_url}/test", {conent: content, test: test}.to_json)
    [response['out'], response['exit'] == 0 ? :passed : :failed]
  rescue Exception => e
    [e.message, :failed]
  end

end
