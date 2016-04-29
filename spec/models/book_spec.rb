require 'spec_helper'

describe Book do
  let(:book) { Organization.current.book }

  describe '#rebuild!' do
    let(:chapter_1) { build(:chapter) }
    let(:chapter_2) { build(:chapter) }

    let(:guide_1) { create(:guide) }
    let(:guide_2) { create(:guide) }
    let(:guide_3) { create(:guide) }

    context 'when chapter is rebuilt after book rebuilt' do
      before do
        book.preface = '#foo'
        book.rebuild!([chapter_1, chapter_2])


        chapter_1.rebuild!([guide_1, guide_2])
        chapter_2.rebuild!([guide_3])
      end

      it { expect(book.reload.preface).to eq '#foo' }
      it { expect(book.reload.preface_html).to eq "<h1>foo</h1>\n" }

      it { expect(Chapter.all).to eq [chapter_1, chapter_2] }
      it { expect(chapter_1.guides).to eq [guide_1, guide_2] }
      it { expect(chapter_2.guides).to eq [guide_3] }
    end

    context 'when chapter is created before book rebuilt' do
      before do
        chapter_1.save!
        chapter_2.save!

        book.preface = '#foo'
        book.rebuild!([chapter_1, chapter_2])

        chapter_1.rebuild!([guide_1, guide_2])
        chapter_2.rebuild!([guide_3])
      end

      it { expect(book.reload.preface).to eq '#foo' }
      it { expect(book.reload.preface_html).to eq "<h1>foo</h1>\n" }

      it { expect(Chapter.all).to eq [chapter_1, chapter_2] }
      it { expect(chapter_1.guides).to eq [guide_1, guide_2] }
      it { expect(chapter_2.guides).to eq [guide_3] }
    end

    context 'when chapter is rebuilt before book rebuilt' do
      before do
        chapter_1.rebuild!([guide_1, guide_2])
        chapter_2.rebuild!([guide_3])

        book.preface = '#foo'
        book.rebuild!([chapter_1, chapter_2])
      end

      it { expect(book.reload.preface).to eq '#foo' }
      it { expect(book.reload.preface_html).to eq "<h1>foo</h1>\n" }

      it { expect(Chapter.all).to eq [chapter_1, chapter_2] }
      it { expect(chapter_1.guides).to eq [guide_1, guide_2] }
      it { expect(chapter_2.guides).to eq [guide_3] }
    end
  end
end