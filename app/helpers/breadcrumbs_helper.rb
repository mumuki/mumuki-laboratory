module BreadcrumbsHelper

  def breadcrumbs(e, extra=nil)
    breadcrumbs0(e.navigable_name, e, extra, 'last')
  end

  def home_breadcrumb
    "<li class='mu-breadcrumb-list-item brand '>#{breadcrumb_home_link}</li>".html_safe
  end

  def breadcrumb_home_link
    if Organization.current.breadcrumb_image_url.present?
      link_to image_tag(Organization.current.breadcrumb_image_url, class: "da mu-breadcrumb-img"), root_path
    else
      link_to "<i class='da da-mumuki' aria-label=#{t(:home)}></i>".html_safe, root_path
    end
  end

  def breadcrumb_item_class(last)
    "class='mu-breadcrumb-list-item #{last}'"
  end

  def breadcrumb_list_item(last, item)
    "<li #{breadcrumb_item_class(last)}>#{h item}</li>".html_safe
  end

  private

  def breadcrumbs_for_linkable(e, extra=nil, last='')
    breadcrumbs0(link_to_path_element(e), e, extra, last)
  end

  def breadcrumbs0(base, e, extra, last)
    return "#{breadcrumbs_for_linkable(e)} #{breadcrumb_list_item(last, extra)}".html_safe if extra

    if e.navigation_end?
      "#{home_breadcrumb} #{breadcrumb_list_item(last, base)}".html_safe
    else
      "#{breadcrumbs_for_linkable(e.navigable_parent)} #{breadcrumb_list_item(last, base)}".html_safe
    end
  end
end
