require 'spec_helper'

describe Rack::Request do
  let(:rack_request) { Rack::Request.new 'HTTP_HOST' => 'foo.bar.baz.com',
                                         'rack.url_scheme' => 'http',
                                         'SERVER_PORT' => '80' }

  it { expect(rack_request.first_subdomain_after('baz.com')).to eq 'foo' }
  it { expect(rack_request.first_subdomain_after('bar.baz.com')).to eq 'foo' }
  it { expect(rack_request.first_subdomain_after('foo.bar.baz.com')).to be nil }

  it { expect(rack_request.empty_subdomain_after?('bar.baz.com')).to be false }
  it { expect(rack_request.empty_subdomain_after?('foo.bar.baz.com')).to be true }
end
