class BookDiscussionsController < DiscussionsController
  def terms
    @forum_terms ||= Term.forum_related_terms
  end

  private

  def set_debatable
    @debatable = Organization.current.book
  end
end
