require 'spec_helper'

describe Book do
  let!(:haskell) { create(:haskell) }
  let!(:gobstones) { create(:gobstones) }

  let!(:guide_1) { create(:guide, name: 'a lesson') }
  let!(:guide_2) { create(:guide, name: 'other lesson') }

  let!(:topic_1) { create(:topic, name: 'a topic') }
  let!(:topic_2) { create(:topic, name: 'other topic') }

  let(:book) { Organization.current.book }

  let(:book_json) do
    {name: 'sample book',
     description: 'a sample book description',
     slug: 'mumuki/mumuki-sample-book',
     locale: 'en',
     chapters: [topic_1.slug, topic_2.slug],
     complements: [guide_2.slug, guide_1.slug]
    }.deep_stringify_keys
  end

  describe '#import_from_json!' do
    before do
      book.import_from_json!(book_json)
    end

    it { expect(book.name).to eq 'sample book' }
    it { expect(book.description).to eq 'a sample book description' }
    it { expect(book.locale).to eq 'en' }
    it { expect(book.chapters.count).to eq 2 }
    it { expect(book.complements.count).to eq 2 }

    it { expect(topic_2.reload.usage_in_organization).to be_a Chapter }
    it { expect(guide_2.reload.usage_in_organization).to be_a Complement }
  end
end
