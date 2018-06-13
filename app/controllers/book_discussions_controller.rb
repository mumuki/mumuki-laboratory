class BookDiscussionsController < DiscussionsController
  def index
    @discussions = Discussion.custom_sort(@filter_params)
  end

  def set_debatable
    @debatable = Organization.current.book
  end
end
