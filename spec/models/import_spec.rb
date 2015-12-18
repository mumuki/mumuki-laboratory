require 'spec_helper'

describe Guide do
  describe '#import_from_json!' do

    let!(:haskell) { create(:haskell) }
    let(:guide) { create(:guide, exercises: [create(:exercise)]) }

    let(:guide_json) {
      {name: 'sample guide',
       description: 'Baz',
       slug: 'mumuki/sample-guide',
       language: 'haskell',
       locale: 'en',
       exercises: [
           {type: 'problem',
            name: 'Bar',
            description: 'a description',
            test: 'foo bar',
            tag_list: %w(baz bar),
            layout: 'no_editor',
            original_id: 1},

           {type: 'playground',
            description: 'lorem ipsum',
            name: 'Foo',
            tag_list: %w(foo bar),
            original_id: 4},

           {name: 'Baz',
            description: 'lorem ipsum',
            tag_list: %w(baz bar),
            layout: 'editor_bottom',
            type: 'problem',
            expectations: [{inspection: 'HasBinding', binding: 'foo'}],
            original_id: 2}]}.deep_stringify_keys }

    before do
      guide.import_from_json!(guide_json)
    end

    it { expect(guide).to_not be nil }
    it { expect(guide.name).to eq 'sample guide' }
    it { expect(guide.language).to eq haskell }
    it { expect(guide.slug).to eq 'mumuki/sample-guide' }
    it { expect(guide.description).to eq 'Baz' }
    it { expect(guide.friendly_name).to include 'sample-guide' }

    it { expect(guide.exercises.count).to eq 3 }
    it { expect(guide.exercises.first.language).to eq haskell }
    it { expect(guide.exercises.first.friendly_name).to include 'sample-guide-bar' }

    it { expect(guide.exercises.pluck(:name)).to eq %W(Bar Foo Baz) }
  end
end
