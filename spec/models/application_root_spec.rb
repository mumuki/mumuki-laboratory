require 'spec_helper'

describe ApplicationRoot do
  it { expect(ApplicationRoot.laboratory.url_for 'foo', '/foo/baz').to eq 'http://foo.localmumuki.io:3000/foo/baz' }
  it { expect(ApplicationRoot.classroom.url_for 'foo', '/foo/baz').to eq 'http://foo.classroom.mumuki.io/foo/baz' }
  it { expect(ApplicationRoot.office.url).to eq 'http://office.mumuki.io' }
end
