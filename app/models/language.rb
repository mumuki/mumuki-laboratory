require 'mumukit/bridge'

class Mumukit::Bridge::Runner
  def post_to_server(request, route)
    JSON.parse RestClient::Request.new(
                   method: :post,
                   url: "#{test_runner_url}/#{route}",
                   payload: request.to_json,
                   timeout: 10,
                   open_timeout: 10,
                   headers: {content_type: :json}).execute()
  end
end


class Language < ActiveRecord::Base
  include WithCaseInsensitiveSearch

  enum output_content_type: [:plain, :html, :markdown]

  validates_presence_of :test_runner_url, :devicon, :output_content_type

  validates :name, presence: true, uniqueness: {case_sensitive: false}

  markdown_on :test_syntax_hint, :description

  delegate :run_tests!, :run_query!, to: :bridge

  def prompt
    self[:prompt] || 'ム '
  end

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
