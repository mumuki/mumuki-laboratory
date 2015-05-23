require 'spec_helper'

describe ContentType do

  describe 'html' do
    let(:html) { ContentType.for(:html) }
    it { expect(html.to_html('<h1>foo</h1>').html_safe?).to be true }
    it { expect(html.to_html('<pre>foo</pre>')).to eq '<pre>foo</pre>' }
  end

  describe 'markdown' do
    let(:markdown) { ContentType.for(:markdown) }
    it { expect(markdown.to_html('#foo').html_safe?).to be true }
  end

  describe 'plain' do
    let(:plain) { ContentType.for(:plain) }
    it { expect(plain.to_html('foo').html_safe?).to be true }
    it { expect(plain.to_html('foo')).to eq '<pre>foo</pre>' }
    it { expect(plain.to_html('x < 5 && x > 0')).to eq '<pre>x &lt; 5 &amp;&amp; x &gt; 0</pre>' }
  end
end
