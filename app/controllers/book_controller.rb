class BookController < ApplicationController

  def show
    @book = Organization.current.book
    @exams = Organization.current.accessible_exams_for current_user
  end
end
