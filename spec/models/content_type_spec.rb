require 'spec_helper'

describe ContentType do
  it { expect(ContentType.for(:html).to_html('<h1>foo</h1>').html_safe?).to be true }
  it { expect(ContentType.for(:plain).to_html('foo').html_safe?).to be false }
  it { expect(ContentType.for(:markdown).to_html('#foo').html_safe?).to be true }
end
