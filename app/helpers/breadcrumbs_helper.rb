module BreadcrumbsHelper
  def breadcrumbs(e, extra=nil)
    breadcrumbs0(e.navigable_name, e, extra, 'last')
  end

  def home_and_organization_breadcrumbs
    "#{home_breadcrumb} #{organization_breadcrumb}".html_safe
  end

  def home_breadcrumb
    home = "<i class='da da-mumuki' aria-label=#{t(:home)}></i>".html_safe
    breadcrumb_list_item_with_link home, mu_home_path, 'brand'
  end

  def mu_home_path
    root_path
  end

  def organization_breadcrumb
    Organization.current.breadcrumb_image_url.present? ? organization_image_breadcrumb : organization_text_breadcrumb
  end

  def organization_image_breadcrumb
    image = image_tag(Organization.current.breadcrumb_image_url, class: "da mu-breadcrumb-img")
    breadcrumb_list_item_with_link image, root_path
  end

  def organization_text_breadcrumb
    breadcrumb_list_item_with_link organization_name, root_path
  end

  def organization_name
    Organization.current.name
  end

  def breadcrumb_item_class(clazz)
    "class='mu-breadcrumb-list-item #{clazz}'"
  end

  def breadcrumb_list_item(clazz, item)
    "<li #{breadcrumb_item_class(clazz)}>#{h item}</li>".html_safe
  end

  def breadcrumb_list_item_with_link(item, where_to, brand='')
    breadcrumb_list_item brand, (link_to item, where_to)
  end

  private

  def breadcrumbs_for_linkable(e, extra=nil, last='')
    breadcrumbs0(link_to_path_element(e), e, extra, last)
  end

  def breadcrumbs0(base, e, extra, last)
    return "#{breadcrumbs_for_linkable(e)} #{breadcrumb_list_item(last, extra)}".html_safe if extra

    if e.navigation_end?
      "#{home_and_organization_breadcrumbs} #{breadcrumb_list_item(last, base)}".html_safe
    else
      "#{breadcrumbs_for_linkable(e.navigable_parent)} #{breadcrumb_list_item(last, base)}".html_safe
    end
  end
end
