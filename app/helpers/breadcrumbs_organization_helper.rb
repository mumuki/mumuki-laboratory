module BreadcrumbsOrganizationHelper
  def organization_breadcrumb(has_link)
    Organization.current.breadcrumb_image_url.present? ? image_breadcrumb(has_link) : text_breadcrumb(has_link)
  end

  private

  def image_breadcrumb(has_link)
    image = image_tag Organization.current.breadcrumb_image_url, class: "da mu-breadcrumb-img"
    link_breadcrumb_if has_link, image
  end

  def text_breadcrumb(has_link)
    link_breadcrumb_if has_link, organization_name
  end

  def link_breadcrumb_if(has_link, item)
    has_link ? breadcrumb_list_item_with_link(item, root_path) : breadcrumb_list_item(item)
  end

  def organization_name
    Organization.current.name
  end
end
