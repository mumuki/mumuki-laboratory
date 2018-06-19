class BookDiscussionsController < DiscussionsController
  def index
    @discussions = Discussion.search_by(params)
  end

  def set_debatable
    @debatable = Organization.current.book
  end
end
