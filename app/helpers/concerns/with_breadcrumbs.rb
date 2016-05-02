module WithBreadcrumbs
  def breadcrumbs(e)
    base = link_to_path_element e
    if e.respond_to?(:orphan?) && !e.orphan?
      "#{breadcrumbs(e.navigable_parent)} <li>#{base}</li>".html_safe
    else
      "#{home_breadcrumb}<li>#{base}</li>".html_safe
    end
  end

  def home_breadcrumb
    "<li><span class=\"ahahamojimoji\">#{link_to 'ム', root_path }</span></li>".html_safe
  end
end
