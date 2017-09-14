module BreadcrumbsHelper

  def breadcrumbs(e, extra=nil)
    breadcrumbs0(e, extra, 'last')
  end

  def home_breadcrumb
    "<li class='mu-breadcrumb-list-item brand '>#{link_to "<i class='da da-mumuki' aria-label=#{t(:home)}></i>".html_safe, root_path }</li>".html_safe
  end

  def breadcrumb_item_class(last)
    <<HTML
    class='mu-breadcrumb-list-item #{last}'
HTML
  end

  private

  def breadcrumbs0(e, extra=nil, last='')
    return "#{breadcrumbs0(e)}<li #{breadcrumb_item_class(last)} >#{extra}</li>".html_safe if extra

    base = link_to_path_element e
    if e.navigation_end?
      "#{home_breadcrumb}<li #{breadcrumb_item_class(last)}>#{base}</li>".html_safe
    else
      "#{breadcrumbs0(e.navigable_parent)} <li #{breadcrumb_item_class(last)}>#{base}</li>".html_safe
    end
  end
end
