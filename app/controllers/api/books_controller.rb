class Api::BooksController < Api::BaseController
  def create
    book = Book.find_or_create_by(slug: params[:slug])
    book.import!
    render json: { topic: book.as_json }
  end
end
