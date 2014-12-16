module Pagination
  def paginated(relation)
    relation.page params[:page]
  end
end