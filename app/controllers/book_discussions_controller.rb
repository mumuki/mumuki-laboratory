class BookDiscussionsController < DiscussionsController
  private

  def set_debatable
    @debatable = Organization.current.book
  end
end
