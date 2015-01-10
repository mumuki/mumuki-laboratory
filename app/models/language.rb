require 'rest_client'

class Language < ActiveRecord::Base
  belongs_to :plugin_author, class_name: 'User'

  validates_presence_of :name, :test_runner_url, :extension, :image_url

  def run_tests!(test, content)
    response = JSON.parse RestClient.post("#{test_runner_url}/test", {content: content, test: test}.to_json)
    [response['out'], response['exit']]
  rescue Exception => e
    [e.message, :failed]
  end

  def created_by? user
    user.id == plugin_author.id
  end

  def to_s
    name
  end
end
