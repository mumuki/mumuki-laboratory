require 'spec_helper'

describe ContentType do
  it { expect(ContentType.for(:html).render('<h1>foo</h1>').html_safe?).to be true }
  it { expect(ContentType.for(:plain).render('foo').html_safe?).to be false }
  it { expect(ContentType.for(:markdown).render('#foo').html_safe?).to be true }
end
