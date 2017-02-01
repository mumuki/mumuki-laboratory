require 'spec_helper'

describe Mumukit::Navigation::Application do
  let(:app) { Mumukit::Navigation::Application.new('http://gugle.com') }

  it { expect(app.subdominated_url_for 'foo', '/foo/baz').to eq 'http://foo.gugle.com/foo/baz' }
  it { expect(app.url).to eq 'http://gugle.com' }
end
