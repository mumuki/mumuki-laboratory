module WithScopedQueries::Page
  def self.query_by(params, current_scope, _)
    page_param = params[:page] || 1
    if page_param.present?
      current_scope.paginate(page: page_param)
    end
  end

  def self.add_queriable_attributes_to(klass, _)
    klass.queriable_attributes.merge!(page: :page)
  end
end
