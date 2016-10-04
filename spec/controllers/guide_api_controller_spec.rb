require 'spec_helper'

describe Api::GuidesController do
  describe 'post' do
    let!(:haskell) { create(:haskell) }
    let(:imported_guide) { Guide.find_by(slug: 'flbulgarelli/sample-guide') }
    let(:first_imported_exercise) { imported_guide.exercises.first }
    let(:guide_json) {
      {
          name: 'sample guide',
          description: 'Baz',
          slug: 'flbulgarelli/sample-guide',
          language: 'haskell',
          locale: 'en',
          expectations: [{inspection: 'HasBinding', binding: 'foo'}],
          exercises: [
              {type: 'problem',
               name: 'Bar',
               description: 'a description',
               test: 'foo bar',
               default_content: 'foo',
               extra_visible: true,
               tag_list: %w(baz bar),
               layout: 'input_bottom',
               expectations: [{inspection: 'HasBinding', binding: 'bar'}],
               id: 1}]}
    }
    before { allow_any_instance_of(Mumukit::Bridge::Bibliotheca).to receive(:guide).and_return(guide_json.deep_stringify_keys) }
    before { post :create, {slug: 'flbulgarelli/sample-guide'} }

    it { expect(response.status).to eq 200 }
    it { expect(imported_guide).to_not be nil }
    it { expect(imported_guide.name).to eq 'sample guide' }
    it { expect(imported_guide.language).to eq haskell }
    it { expect(imported_guide.exercises.count).to eq 1 }
    it { expect(first_imported_exercise.default_content).to eq 'foo' }
    it { expect(first_imported_exercise.extra_visible).to be true }
    it { expect(first_imported_exercise.expectations).to eq [{'inspection' => 'HasBinding', 'binding' => 'bar'},
                                                             {'inspection' => 'HasBinding', 'binding' => 'foo'}] }
  end
end
