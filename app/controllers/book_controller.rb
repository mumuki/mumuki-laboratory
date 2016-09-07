class BookController < ApplicationController

  def show
    @book = Organization.book
    @exams = Organization.accessible_exams_for current_user
  end
end
