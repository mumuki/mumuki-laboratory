module Searchable
  extend ActiveSupport::Concern

  class_methods do
    def filter(filtering_params)
      results = all
      filtering_params.each do |key, value|
        results = results.public_send(key, value) if value.present?
      end
      results
    end

    def custom_sort(params)
      results = all
      sorting_field = params[:sort]
      return results unless sortable_fields.include? sorting_field
      if self.column_names.includes? sorting_field
        results.public_send(order, sorting_field)
      else
        results.public_send("order_by_#{sorting_field}")
      end
    end

    # should define sortable_fields

  end
end
