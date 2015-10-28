require 'spec_helper'

describe Import do

  let!(:hasell) { create(:haskell) }
  let(:guide) { create(:guide) }
  let(:import) { Import.new guide: guide }

  let(:guide_json) {
    {name: 'sample guide',
     description: 'Baz',
     github_repository: 'flbulgarelli/sample-guide',
     language: 'haskell',
     locale: 'en',
     original_id_format: '%05d',
     exercises: [
         {type: 'problem',
          name: 'Bar',
          description: 'a description',
          test: 'foo bar',
          tag_list: %w(baz bar),
          layout: 'no_editor',
          original_id: 1},

         {type: 'playground',
          name: 'Foo',
          tag_list: %w(foo bar),
          original_id: 4},

         {name: 'Baz',
          tag_list: %w(baz bar),
          layout: 'editor_bottom',
          type: 'problem',
          original_id: 2}]}.deep_stringify_keys }

  before do
    import.read_from_json(guide_json)
    guide.reload
  end

  it { expect(guide).to_not be nil }
  it { expect(guide.name).to eq 'sample guide' }
  it { expect(guide.exercises.count).to eq 3 }
  it { expect(guide.exercises.first.language).to eq haskell }

end