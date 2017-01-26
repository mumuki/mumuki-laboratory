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

describe Mumukit::Login::User do
  it { expect(Mumukit::Login::User).to be User }

end

describe Mumukit::Login do
  let(:provider) { Mumukit::Login.config.provider }

  it { expect(provider).to be_a Mumukit::Login::Provider::Developer }
  it { expect(provider.name).to eq 'developer' }
end

describe Mumukit::Login::Form do
  let(:controller) { double(:controller) }
  let(:login_settings) { Mumukit::Login::Settings.new }
  let(:provider) { Mumukit::Login::Provider::Auth0.new }

  let(:builder) { Mumukit::Login::Form.new(provider, controller, login_settings) }

  before { allow(controller).to receive(:request).and_return(struct path: 'http://localmumuki.io/foo') }

  it { expect(builder.footer_html).to be_html_safe }
  it { expect(builder.header_html).to be_html_safe }
  it { expect(builder.button_html('login', 'clazz')).to be_html_safe }
end

describe Mumukit::Login::Controller do
  let(:framework) { double(:framework) }
  let(:controller) { Mumukit::Login::Controller.new framework }

  before { allow(framework).to receive(:env).and_return('HTTP_HOST' => 'localmumuki.io',
                                                        'rack.url_scheme' => 'http',
                                                        'SERVER_PORT' => '80') }

  it { expect(controller.request).to be_a Rack::Request }
  it { expect(controller.url_for('/foo/bar')).to eq 'http://localmumuki.io/foo/bar' }
end

describe Mumukit::Login::Provider do
  let(:controller) { double(:controller) }
  let(:provider) { Mumukit::Login.config.provider }
  let(:login_settings) { Mumukit::Login::Settings.new }

  before { allow(controller).to receive(:request).and_return(struct path: '/foo') }

  describe Mumukit::Login::Provider::Developer do
    let(:provider) { Mumukit::Login::Provider::Developer.new }

    it { expect(provider.button_html(controller, 'login', 'clazz')).to eq '<a class="clazz" href="/login?origin=/foo">login</a>' }
    it { expect(provider.header_html(controller)).to be_blank }
    it { expect(provider.footer_html(controller)).to be_blank }
  end

  describe Mumukit::Login::Provider::Auth0 do
    let(:provider) { Mumukit::Login::Provider::Auth0.new }


    before { allow(controller).to receive(:url_for).with('/auth/auth0/callback').and_return('http://localmumuki.io/auth/auth0/callback') }

    it { expect(provider.button_html(controller, 'login', 'clazz')).to eq '<a class="clazz" href="/login?origin=/foo">login</a>' }
    it { expect(provider.header_html(controller, login_settings)).to be_present }
    it { expect(provider.header_html(controller, login_settings)).to include 'https://cdn.auth0.com/js/lock-7.12.min.js' }
    it { expect(provider.header_html(controller, login_settings)).to_not include 'http://localmumuki.io/auth/auth0/callback' }

    it { expect(provider.footer_html(controller)).to be_present }
    it { expect(provider.footer_html(controller)).to include '//cdn.auth0.com/oss/badges/a0-badge-light.png' }

  end

  describe Mumukit::Login::Provider::Saml do
    let(:provider) { Mumukit::Login::Provider::Saml.new }

    it { expect(provider.button_html(controller, 'login', 'clazz')).to eq '<a class="clazz" href="/login?origin=/foo">login</a>' }
    it { expect(provider.header_html(controller)).to be_blank }
    it { expect(provider.footer_html(controller)).to be_blank }
  end
end
