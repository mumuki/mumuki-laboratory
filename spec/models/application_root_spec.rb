require 'spec_helper'

describe ApplicationRoot do
  it { expect(ApplicationRoot.url_for 'foo', '/foo/baz').to eq 'http://foo.localmumuki.io:3000/foo/baz' }
end
