require 'spec_helper'

describe Chapter do
  let!(:functional) { build(:chapter, name: 'Functional Programming') }
  let!(:haskell) { build(:language, name: 'haskell') }
  let(:guide) { build(:guide, github_repository: 'flbulgarelli/mumuki-sample-exercises', author: 'author', chapter: functional) }

  it { expect(functional.name).to eq 'Functional Programming' }
end
