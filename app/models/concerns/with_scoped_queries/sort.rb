module WithScopedQueries::Sort
  extend ActiveSupport::Concern

  included do
    class_attribute :sorting_fields, :default_sorting_field, instance_writer: false
  end

  def self.query_by(params, scope, klass)
    sort_param = params[:sort] || klass.default_sorting_field.to_s
    normalized_params = normalize_params(sort_param)
    if sort_param.present? && klass.sorting_params_allowed?(*normalized_params)
      sort_method_for(klass, scope, *normalized_params)
    else
      scope
    end
  end

  def self.normalize_params(param)
    param&.split(/_(?!.*_)/)
  end

  def self.add_queriable_attributes_to(klass, attributes)
    klass.default_sorting_field = attributes.extract_options![:default]
    klass.sorting_fields = attributes
    klass.queriable_attributes.merge!(sort: :sort)
  end

  def self.sort_method_for(klass, scope, field, direction)
    if klass.column_names.include? field
      scope.public_send(:reorder, "#{klass.table_name}.#{field} #{direction}")
    else
      scope.public_send("order_by_#{field}", direction)
    end
  end

  class_methods do
    def sorting_filters
      sorting_fields.product([:asc, :desc]).map do |it|
        "#{it.first}_#{it.second}"
      end
    end

    def sorting_params_allowed?(sort_param, direction_param=nil)
      sorting_fields.include?(sort_param.to_sym) && [:asc, :desc].include?(direction_param&.to_sym)
    end
  end
end
