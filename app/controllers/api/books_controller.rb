class Api::BooksController < Api::BaseController
  def create
    book = Book.import!(params[:slug])
    render json: { topic: book.as_json }
  end
end
