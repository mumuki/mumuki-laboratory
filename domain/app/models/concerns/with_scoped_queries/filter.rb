module WithScopedQueries::Filter
  def self.query_by(params, current_scope, _)
    params.to_h.inject(current_scope) do |scope, (field, value)|
      if value.present?
        scope.public_send("by_#{field}", value)
      else
        scope
      end
    end
  end

  def self.add_queriable_attributes_to(klass, attributes)
    klass.queriable_attributes.merge!(filter: attributes)
  end
end
