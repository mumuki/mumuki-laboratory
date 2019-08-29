module OrganizationBreadcrumbsHelper
  def organization_breadcrumb(has_link: true)
    clazz = 'last' unless has_link
    breadcrumb_item_for_linkable(organization_breadcrumb_item_content, root_path, clazz)
  end

  private

  def organization_breadcrumb_item_content(organization=Organization.current)
    if organization.breadcrumb_image_url.present?
      breadcrumb_image_for organization
    else
      breadcrumb_text_for organization
    end
  end

  def breadcrumb_image_for(organization)
    image_tag organization.breadcrumb_image_url, class: "da mu-breadcrumb-img"
  end

  def breadcrumb_text_for(organization)
    organization.name
  end
end
