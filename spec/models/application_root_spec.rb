require 'spec_helper'

describe Mumukit::Platform::Application do
  it { expect(Mumukit::Platform.laboratory.organic_url_for 'foo', '/foo/baz').to eq 'http://foo.localmumuki.io/foo/baz' }
  it { expect(Mumukit::Platform.classroom.organic_url_for 'foo', '/foo/baz').to eq 'http://foo.classroom.localmumuki.io/foo/baz' }
  it { expect(Mumukit::Platform.office.url).to eq 'http://office.localmumuki.io' }

  it { expect(Mumukit::Platform::OrganicApplication.new('http://foo.com:3000').organic_url('bar')).to eq 'http://bar.foo.com:3000' }
end
