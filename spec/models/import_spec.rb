require 'spec_helper'

describe Guide do
  describe '#import_from_json!' do
    context 'when guide is empty' do
      let!(:haskell) { create(:haskell) }
      let(:guide) { create(:guide, exercises: []) }

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
              id: 1},

             {type: 'playground',
              description: 'lorem ipsum',
              name: 'Foo',
              tag_list: %w(foo bar),
              id: 4},

             {name: 'Baz',
              description: 'lorem ipsum',
              tag_list: %w(baz bar),
              layout: 'editor_bottom',
              type: 'problem',
              expectations: [{inspection: 'HasBinding', binding: 'foo'}],
              id: 2}]}.deep_stringify_keys }

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

      it { expect(guide.exercises.last.expectations.first['binding']).to eq 'foo' }

      it { expect(guide.exercises.pluck(:name)).to eq %W(Bar Foo Baz) }
    end

    context 'when exercise already exists' do
      let(:language) { create(:language) }
      let(:exercise_1) { create(:exercise,
                                language: language,
                                name: 'Exercise 1',
                                description: 'description',
                                test: 'test',
                                corollary: 'A corollary',
                                hint: 'baz',
                                extra: 'foo',
                                expectations: [{binding: 'foo', inspection: 'HasBinding'}]) }
      let(:guide) { create(:guide, language: language, exercises: [exercise_1]) }

      context 'when there are nil imported fields' do
        let(:json) { {
            'locale' => 'es',
            'language' => language.name,
            'exercises' => [
                {'name' => 'Exercise 2',
                 'description' => 'foo',
                 'test' => 'test',
                 'type' => 'problem',
                 'corollary' => nil,
                 'hint' => nil,
                 'extra' => nil,
                 'expectations' => []}]} }

        before { guide.import_from_json! json }

        it { expect(guide.exercises[0].name).to eq 'Exercise 2' }
        it { expect(guide.exercises[0].corollary).to be_blank }
        it { expect(guide.exercises[0].extra).to be_blank }
        it { expect(guide.exercises[0].hint).to be_blank }
        it { expect(guide.exercises[0].expectations).to be_blank }
      end

      context 'when missing imported fields' do
        let(:json) { {
            'locale' => 'es',
            'language' => language.name,
            'exercises' => [
                {'name' => 'Exercise 2',
                 'description' => 'foo',
                 'test' => 'test',
                 'type' => 'problem'}]} }

        before { guide.import_from_json! json }

        it { expect(guide.exercises[0].name).to eq 'Exercise 2' }
        it { expect(guide.exercises[0].corollary).to be_blank }
        it { expect(guide.exercises[0].extra).to be_blank }
        it { expect(guide.exercises[0].hint).to be_blank }
        it { expect(guide.exercises[0].expectations).to be_blank }
      end
    end
  end
end
