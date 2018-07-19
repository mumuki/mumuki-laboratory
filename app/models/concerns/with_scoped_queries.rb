module WithScopedQueries
  extend ActiveSupport::Concern

  SCOPING_METHODS = [Filter, Sort, Page]

  included do
    class_attribute :queriable_attributes, instance_writer: false
    self.queriable_attributes = {}

    SCOPING_METHODS.each do |mod|
      define_singleton_method "#{mod.name.demodulize.underscore}able" do |*attributes|
        include mod
        mod.add_queriable_attributes_to(self, attributes)
      end
    end
  end

  class_methods do
    def query_methods
      queriable_attributes.keys
    end

    def scoped_query_module(method)
      "WithScopedQueries::#{method.to_s.camelcase}".constantize
    end

    def permitted_query_params
      queriable_attributes.values.flatten
    end

    def actual_params(params, excluded_param)
      params.reject { |it| it == excluded_param.to_s }
    end

    def scoped_query_by(params, excluded_param=nil)
      query_methods.inject(all) do |scope, method|
        valid_params = valid_params_for(method, params, excluded_param)
        scoped_query_module(method).query_by valid_params, scope, self
      end
    end

    def valid_params_for(method, params, excluded_param)
      actual_params = actual_params(params, excluded_param)
      actual_params.permit queriable_attributes[method]
    end
  end
end
