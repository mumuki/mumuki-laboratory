require 'spec_helper'

describe ContentType do
  it { expect(ContentType.for(:html).render('foo').html_safe?).to be true }
  it { expect(ContentType.for(:plain).render('foo').html_safe?).to be false }
end
