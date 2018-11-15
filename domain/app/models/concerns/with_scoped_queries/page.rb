module WithScopedQueries::Page
  def self.query_by(params, current_scope, _)
    page_param = params[:page] || 1
    current_scope.page(page_param)
  end

  def self.add_queriable_attributes_to(klass, _)
    klass.queriable_attributes.merge!(page: :page)
  end
end
