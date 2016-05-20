require 'spec_helper'

describe Api::BooksController do
  describe 'post' do
    let(:imported_book) { Book.find_by(slug: 'mumuki/mumuki-book-sample') }
    let(:topic) { create(:topic) }
    let(:book_json) do
      {name: 'sample book',
       description: 'book description',
       slug: 'mumuki/mumuki-book-sample',
       locale: 'en',
       chapters: [topic].map(&:slug)}.deep_stringify_keys
    end

    before { expect_any_instance_of(Mumukit::Bridge::Bibliotheca).to receive(:book).and_return(book_json) }
    before { post :create, {slug: 'mumuki/mumuki-book-sample'} }

    it { expect(response.status).to eq 200 }
    it { expect(imported_book).to_not be nil }
    it { expect(imported_book.name).to eq 'sample book' }
    it { expect(imported_book.chapters.count).to eq 1 }
  end
end
