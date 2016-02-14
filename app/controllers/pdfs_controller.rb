class PdfsController < ApplicationController
  def show
    @book = Book.current
    render 'show', layout: nil
  end
end