module OrganizationBreadcrumbsHelper
  def organization_breadcrumb(has_link: false)
    link_breadcrumb_if(has_link, image_or_text_breadcrumb)
  end

  private

  def image_or_text_breadcrumb
    Organization.current.breadcrumb_image_url.present? ? image_breadcrumb : text_breadcrumb
  end

  def image_breadcrumb
    image_tag Organization.current.breadcrumb_image_url, class: "da mu-breadcrumb-img"
  end

  def text_breadcrumb
    Organization.current.name
  end

  def link_breadcrumb_if(has_link, item)
    has_link ? breadcrumb_list_item_with_link(item, root_path) : breadcrumb_list_item(item)
  end
end
