require 'spec_helper'

describe ApplicationController do
  it 'referer from mumuki' do
    allow(request).to receive(:referer).and_return('http://mumuki.io')
    expect(controller.request_host_include?(['mumuki'])).to be_true
    expect(controller.request_host_include?(['foo'])).to be_false
    expect(controller.from_internet?).to be_false
  end

  it 'referer from internet' do
    allow(request).to receive(:referer).and_return('http://google.com')
    expect(controller.from_internet?).to be_true
  end
end
