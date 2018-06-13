module Searchable
  extend ActiveSupport::Concern #FIXME: split this into several concerns and avoid overloading model

  included do
    class_attribute :filtering_params, :sorting_fields, instance_writer: false
    self.filtering_params = {}
  end

  class_methods do
    def sortable_by(*selectors)
      self.sorting_fields = selectors
      filtering_params.merge!(sort: :sort)
    end

    def filterable_by(*selectors)
      filtering_params.merge!(filter: selectors)
    end

    def filtering_methods
      filtering_params.keys
    end

    def permitted_filtering_params
      filtering_params.values.flatten
    end

    def search_by(params, excluded_param=nil)
      current_scope = all
      actual_params = params.reject { |it| it ==  excluded_param.to_s }
      filtering_methods.inject(current_scope) do |scope, method|
        public_send("scoped_#{method}_by", valid_params_for(method, actual_params), scope)
      end
    end

    def valid_params_for(method, params)
      params.permit filtering_params[method]
    end

    def scoped_filter_by(params, current_scope)
      params.to_h.inject(current_scope) do |scope, (field, value)|
        if value.present?
          scope.public_send("by_#{field}", value)
        else
          scope
        end
      end
    end

    def scoped_sort_by(params, scope)
      sort_param = params[:sort]
      normalized_params = sort_param&.split(/_(?!.*_)/)
      if sort_param.present? && sorting_params_allowed?(*normalized_params)
        sort_method_for(scope, *normalized_params)
      else
        scope
      end
    end

    def sorting_params_allowed?(sort_param, direction_param=nil)
      sorting_fields.include?(sort_param.to_sym) && [:asc, :desc].include?(direction_param&.to_sym)
    end

    def sort_method_for(scope, field, direction)
      if self.column_names.include? field
        scope.public_send(:order, "#{field} #{direction}")
      else
        scope.public_send("order_by_#{field}", direction)
      end
    end

    def sorting_filters
      sorting_fields.product([:asc, :desc]).map do |it|
        "#{it.first}_#{it.second}"
      end
    end

  end
end
