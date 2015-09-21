require 'spec_helper'

describe Path do
  let!(:functional) { create(:category, name: 'Functional Programming') }
  #let!(:functional){create(:guide,name: 'guia de Haskell')}
  let!(:haskell) { create(:language, name: 'haskell') }
  let!(:functional_haskell) { create(:path, category: functional, language: haskell) }


  context 'when single path' do
    it { expect(functional_haskell.name).to eq 'Functional Programming' }

  end
  context 'when multiple path' do
    let!(:js) { create(:language, name: 'js') }
    let!(:functional_js) { create(:path, category: functional, language: js) }

   it { expect(functional_haskell.name).to eq 'Functional Programming (haskell)' }
  end
end
