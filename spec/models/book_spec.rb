require 'spec_helper'

describe Book do
  let(:book) { Organization.current.book }

  describe '#rebuild!' do
    let(:chapter_1) { build(:chapter) }
    let(:chapter_2) { build(:chapter) }

    let(:lesson_1) { create(:lesson) }
    let(:lesson_2) { create(:lesson) }
    let(:lesson_3) { create(:lesson) }

    let(:guide_1) { lesson_1.guide }
    let(:guide_2) { lesson_2.guide }
    let(:guide_3) { lesson_3.guide }

    context 'when chapter is rebuilt after book rebuilt' do
      before do
        book.preface = '#foo'
        book.rebuild!([chapter_1, chapter_2])


        chapter_1.rebuild!([lesson_1, lesson_2])
        chapter_2.rebuild!([lesson_3])
      end

      it { expect(book.reload.preface).to eq '#foo' }
      it { expect(book.reload.preface_html).to eq "<h1>foo</h1>\n" }

      it { expect(Chapter.count).to eq 2 }
      it { expect(book.chapters).to eq [chapter_1, chapter_2] }
      it { expect(chapter_1.guides).to eq [guide_1, guide_2] }
      it { expect(chapter_2.guides).to eq [guide_3] }
      it { expect(chapter_1.number).to eq 1 }
      it { expect(chapter_2.number).to eq 2 }
    end

    context 'when chapter is created before book rebuilt' do
      before do
        chapter_1.save!
        chapter_2.save!

        book.preface = '#foo'
        book.rebuild!([chapter_1, chapter_2])

        chapter_1.rebuild!([lesson_1, lesson_2])
        chapter_2.rebuild!([lesson_3])
      end

      it { expect(book.reload.preface).to eq '#foo' }
      it { expect(book.reload.preface_html).to eq "<h1>foo</h1>\n" }

      it { expect(Chapter.count).to eq 2 }
      it { expect(book.chapters).to eq [chapter_1, chapter_2] }
      it { expect(chapter_1.guides).to eq [guide_1, guide_2] }
      it { expect(chapter_2.guides).to eq [guide_3] }
      it { expect(chapter_1.number).to eq 1 }
      it { expect(chapter_2.number).to eq 2 }
    end

    context 'when chapter is rebuilt before book rebuilt' do
      before do
        chapter_1.rebuild!([lesson_1, lesson_2])
        chapter_2.rebuild!([lesson_3])

        book.preface = '#foo'
        book.rebuild!([chapter_1, chapter_2])
      end

      it { expect(book.reload.preface).to eq '#foo' }
      it { expect(book.reload.preface_html).to eq "<h1>foo</h1>\n" }

      it { expect(Chapter.count).to eq 2 }
      it { expect(book.chapters).to eq [chapter_1, chapter_2] }
      it { expect(chapter_1.number).to eq 1 }
      it { expect(chapter_2.number).to eq 2 }

      it { expect(chapter_1.guides).to eq [guide_1, guide_2] }
      it { expect(chapter_2.guides).to eq [guide_3] }
    end
  end
end