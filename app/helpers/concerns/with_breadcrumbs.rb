module WithBreadcrumbs
  def breadcrumbs(e, extra=nil)
    return "#{breadcrumbs(e)}<li>#{extra}</li>".html_safe if extra

    base = link_to_path_element e
    if e.navigation_end?
      "#{home_breadcrumb}<li>#{base}</li>".html_safe
    else
      "#{breadcrumbs(e.navigable_parent)} <li>#{base}</li>".html_safe
    end
  end

  def home_breadcrumb
    "<li><span class=\"ahahamojimoji\">#{link_to 'ム', root_path }</span></li>".html_safe
  end
end
