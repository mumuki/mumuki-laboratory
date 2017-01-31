require 'spec_helper'

describe Mumukit::Navbar::Application do
  it { expect(Mumukit::Navbar::Application[:laboratory].url_for 'foo', '/foo/baz').to eq 'http://foo.localmumuki.io:3000/foo/baz' }
  it { expect(Mumukit::Navbar::Application[:classroom].url_for 'foo', '/foo/baz').to eq 'http://foo.classroom.mumuki.io/foo/baz' }
  it { expect(Mumukit::Navbar::Application[:office].url).to eq 'http://office.mumuki.io' }
end
