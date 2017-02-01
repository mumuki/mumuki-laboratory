module ApplicationNavigationHelper

  def link_to_organization(organization)
    link_to t(:go_to_subdomain, url: application_host_for(organization)),
            application_path_for(organization),
            class: 'btn btn-success pull-right'
  end

  def application_host_for(organization)
    laboratory_application.subdominated_uri(organization.name).host
  end

  def application_path_for(organization)
    laboratory_application.subdominated_url_for(organization.name, request.path)
  end

  def laboratory_application
    Mumukit::Navigation::Application[:laboratory]
  end
end
