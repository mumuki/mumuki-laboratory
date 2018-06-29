class BookDiscussionsController < DiscussionsController
  private

  def set_debatable
    @debatable = Organization.current.book
  end

  def set_current_discussions
    @discussions = Discussion.all
  end
end
