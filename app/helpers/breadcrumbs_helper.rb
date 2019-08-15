module BreadcrumbsHelper

  def breadcrumbs(e, extra=nil)
    breadcrumbs0(e.navigable_name, e, extra, 'last')
  end

  def name_me(link, brand='')
    "<li class='mu-breadcrumb-list-item #{brand}'>#{link}</li>".html_safe
  end

  def home_breadcrumb
    link = link_to "<i class='da da-mumuki' aria-label=#{t(:home)}></i>".html_safe, root_path
    name_me link, 'brand'
  end

  def organization_breadcrumb
    if Organization.current.breadcrumb_image_url.present?
      organization_image_breadcrumb
    else
      organization_text_breadcrumb
    end
  end

  def organization_image_breadcrumb
    link = link_to image_tag(Organization.current.breadcrumb_image_url, class: "da mu-breadcrumb-img"), root_path
    name_me link
  end

  def organization_text_breadcrumb
    home_breadcrumb(link_to Organization.current.name, root_path)
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
      "#{home_breadcrumb} #{organization_breadcrumb} #{breadcrumb_list_item(last, base)}".html_safe
    else
      "#{breadcrumbs_for_linkable(e.navigable_parent)} #{breadcrumb_list_item(last, base)}".html_safe
    end
  end
end
