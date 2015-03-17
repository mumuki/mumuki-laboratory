module Pagination
  def paginated(relation, size=10)
    relation.page(params[:page]).per(size)
  end
end
