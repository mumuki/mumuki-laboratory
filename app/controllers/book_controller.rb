class BookController < ApplicationController
  before_action :redirect_to_last_guide_if_possible, only: :show
  before_action :set_book, only: :show
  before_action :set_next_exercise, only: :show

  def show
    set_book
    @exams = Organization.accessible_exams_for current_user
  end


  private

  def set_book
    @book = Organization.book
  end

  def set_next_exercise
    @last_submitted_exercise = current_user.try(:last_submitted_exercise)
    @next_exercise = @last_submitted_exercise || @book.first_exercise
  end

  def redirect_to_last_guide_if_possible
    redirect_to_last_guide if should_redirect?
  end

  def should_redirect?
    visitor_recurrent? && from_internet?
  end
end
