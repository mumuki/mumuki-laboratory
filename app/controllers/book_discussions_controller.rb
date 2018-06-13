class BookDiscussionsController < DiscussionsController
  def index
    @discussions = Discussion.all
    @discussions = @discussions.for_user(current_user)
    @filtered_discussions = @discussions.search_by(@filter_params)
  end

  def set_debatable
    @debatable = Organization.current.book
  end
end
