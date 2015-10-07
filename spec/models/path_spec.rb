require 'spec_helper'

describe Path do
  let!(:functional) { build(:category, name: 'Functional Programming') }
  let!(:haskell) { build(:language, name: 'haskell') }
  let(:guide) { build(:guide, github_repository: 'flbulgarelli/mumuki-sample-exercises', author: 'author',path: functional_haskell) }
  let!(:functional_haskell) { build(:path, category: functional, language: haskell) }



  context 'when single path' do
    it { expect(functional_haskell.name).to eq 'Functional Programming (haskell)' }
  end
  context 'when multiple path' do
    let!(:js) { create(:language, name: 'js') }
    let!(:functional_js) { create(:path, category: functional, language: js) }

   it { expect(functional_haskell.name).to eq 'Functional Programming (haskell)' }
  end
end
