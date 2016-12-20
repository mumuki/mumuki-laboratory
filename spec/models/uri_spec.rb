require 'spec_helper'

def add_extra_subdomain(original_url)
  URI(original_url).subdominate('extra').to_s
end

describe URI do
  it { expect(add_extra_subdomain('http://foo.bar')).to eq 'http://extra.foo.bar' }
  it { expect(add_extra_subdomain('http://foo.bar/zaraza')).to eq 'http://extra.foo.bar/zaraza' }
  it { expect(add_extra_subdomain('http://www.foo.bar.com/')).to eq 'http://www.extra.foo.bar.com/' }
  it { expect(add_extra_subdomain('http://foo.bar.com/foo?z=3')).to eq 'http://extra.foo.bar.com/foo?z=3' }
  it { expect(add_extra_subdomain('http://foo.bar.com:3000/foo?z=3')).to eq 'http://extra.foo.bar.com:3000/foo?z=3' }
end
