require 'spec_helper'


class URI::HTTP
  def add_subdomain(subdomain)
    URI::HTTP.build(scheme: scheme,
                    host: "#{subdomain}.#{host}",
                    path: path,
                    query: query)
  end
end

def add_extra_subdomain(original_url)
  URI(original_url).add_subdomain('extra').to_s
end


describe URI do
  it { expect(add_extra_subdomain('http://foo.bar')).to eq 'http://extra.foo.bar' }
  it { expect(add_extra_subdomain('http://foo.bar/zaraza')).to eq 'http://extra.foo.bar/zaraza' }
  skip { expect(add_extra_subdomain('http://www.foo.bar.com/')).to eq 'http://www.extra.foo.bar.com/' }
  it { expect(add_extra_subdomain('http://foo.bar.com/foo?z=3')).to eq 'http://extra.foo.bar.com/foo?z=3' }
end
