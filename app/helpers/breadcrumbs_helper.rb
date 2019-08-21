module BreadcrumbsHelper
  def breadcrumbs(e, extra=nil)
    breadcrumbs0(e.navigable_name, e, extra, 'last')
  end

  def home_and_organization_breadcrumbs(link_for_organization: false)
    "#{home_breadcrumb} #{organization_breadcrumb link_for_organization}".html_safe
  end

  def home_breadcrumb
    home = "<i class='da da-mumuki' aria-label=#{t(:home)}></i>".html_safe
    breadcrumb_list_item_with_link home, mu_home_path, 'brand'
  end

  def mu_home_path
    root_path
  end

  def breadcrumb_item_class(clazz)
    "class='mu-breadcrumb-list-item #{clazz}'"
  end

  def breadcrumb_list_item(item, clazz='')
    "<li #{breadcrumb_item_class(clazz)}>#{h item}</li>".html_safe
  end

  def breadcrumb_list_item_with_link(item, where_to, brand='')
    breadcrumb_list_item (link_to item, where_to), brand
  end

  private

  def breadcrumbs_for_linkable(e, extra=nil, last='')
    breadcrumbs0(link_to_path_element(e), e, extra, last)
  end

  def breadcrumbs0(base, e, extra, last)
    return "#{breadcrumbs_for_linkable(e)} #{breadcrumb_list_item(extra, last)}".html_safe if extra

    if e.navigation_end?
      "#{home_and_organization_breadcrumbs(link_for_organization: true)} #{breadcrumb_list_item(base, last)}".html_safe
    else
      "#{breadcrumbs_for_linkable(e.navigable_parent)} #{breadcrumb_list_item(base, last)}".html_safe
    end
  end
end
