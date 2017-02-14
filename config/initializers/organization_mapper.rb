module OrganizationMapper
  def self.configure_application_routes(mapper, &block)
    mapper.instance_eval(&block)
  end

  def self.extract_organization_name(request)
    request.first_subdomain_after(Rails.configuration.domain) || 'central'
  end
end
