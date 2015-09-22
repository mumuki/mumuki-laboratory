require 'spec_helper'

describe Path do
  let!(:functional) { create(:category, name: 'Functional Programming') }
  let!(:haskell) { create(:language, name: 'haskell') }
  let(:guide) { create(:guide, github_repository: 'flbulgarelli/mumuki-sample-exercises', author: 'author',path: functional_haskell) }
  let!(:functional_haskell) { create(:path, category: functional, language: haskell) }



  context 'when single path' do
    it { expect(functional_haskell.name).to eq 'Functional Programming (haskell)' }
  end
  context 'when multiple path' do
    let!(:js) { create(:language, name: 'js') }
    let!(:functional_js) { create(:path, category: functional, language: js) }

   it { expect(functional_haskell.name).to eq 'Functional Programming (haskell)' }
  end
end
