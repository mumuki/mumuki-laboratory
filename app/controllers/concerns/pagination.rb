module Pagination
  def paginated(relation, size=10)
    relation.with_pagination.page(params[:page]).per(size)
  end
end
