require 'spec_helper'

describe ChoicesHelper do
  helper ChoicesHelper

  context 'exercise width choices' do
    let(:checked_content) { struct id: '1', index: 0, value: 'foo', text: 'bar' }
    let(:unchecked_content) { struct id: '3', index: 2, value: 'baz', text: 'lorem' }
    let(:content) { '0:1' }
    it { expect(checked? checked_content, content).to be true }
    it { expect(checked? unchecked_content, content).to be false }
    it { expect(checked? unchecked_content, '').to be false }
  end
end
