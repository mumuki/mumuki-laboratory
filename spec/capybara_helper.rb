require 'capybara/rails'
require 'capybara/rspec'

# Test helpers

def page_body
  find('body')
end

def set_request_header!(key, value)
  current_driver = Capybara.current_session.driver
  if current_driver.respond_to? :header
    current_driver.header key, value
  else
    $custom_headers = {key => value}
  end
end

def set_subdomain_host!(subdomain)
  @request.try { |it| it.host = Mumukit::Platform.laboratory.organic_domain subdomain }
  Capybara.app_host = Mumukit::Platform.laboratory.organic_url subdomain
end

def set_implicit_central!
  warn "Implicit behaviour is going to be removed soon"
  @request.try { |it| it.host = Mumukit::Platform.laboratory.domain }
  Capybara.app_host = Mumukit::Platform.laboratory.url
end

# Config helpers

def selected_driver
  case ENV['MUMUKI_SELENIUM_DRIVER']
  when 'chrome'
    :selenium_chrome_headless
  when 'firefox'
    :selenium_headless
  when 'safari'
    :selenium_safari
  end
end

def run_with_selenium?
  selected_driver
end

def register_safari_driver!
  # No official docs for this, code was taken from https://github.com/teamcapybara/capybara/blob/master/spec/selenium_spec_safari.rb
  Capybara.register_driver :selenium_safari do |app|
    Capybara::Selenium::Driver.new(app, browser: :safari, timeout: 30)
  end
end

# Registers a middleware to set request headers, because Selenium Webdriver has no native support for that
def register_request_headers_workaround!
  RSpec.configure do |config|
    config.after(:suite) do
      $custom_headers = nil
    end
  end

  Object.class_eval <<-EOR
    module RequestWithExtraHeaders
      def headers
        $custom_headers.each { |key, value| self.set_header "HTTP_\#{key}", value } if $custom_headers
        super
      end
    end

    class ActionDispatch::Request
      prepend RequestWithExtraHeaders
    end
  EOR
end

def exclude_selenium_failing_tests!
  RSpec.configure do |config|
    config.filter_run_excluding(
      # Response headers are not supported by Selenium Driver
      :http_response_headers,

      # TODO: the following ignored groups should be fixed
      :element_not_interactable_error,
      :toast_interferes_with_view,
      :invalid_selector_error,
      :json_eq_error,
      :navigation_error,
      :organization_not_nil,
      :xpath_no_matches,

      # Fails because Rails redirection doesn't include Capybara port.
      # It can be fixed by using path mapping instead of subdomain.
      :subdomain_redirection_without_port
    )
  end
end

register_safari_driver! if selected_driver == :selenium_safari

# If no driver is selected, it will use RackTest (fastest) except for tests that explicitly require JS support.
# See https://github.com/teamcapybara/capybara#using-capybara-with-rspec for more details about this behavior.
Capybara.default_driver = selected_driver || :rack_test
Capybara.javascript_driver = selected_driver || :selenium_headless

# Include port on the URL, so we don't need to forward it via nginx or so.
Capybara.always_include_port = true

# TODO: fix the tests that depend on hidden elements and remove this
Capybara.ignore_hidden_elements = false

if run_with_selenium?
  register_request_headers_workaround!
  exclude_selenium_failing_tests!
end

puts "Running Capybara tests with #{Capybara.default_driver}, #{Capybara.ignore_hidden_elements ? '' : 'not '}ignoring hidden elements"
