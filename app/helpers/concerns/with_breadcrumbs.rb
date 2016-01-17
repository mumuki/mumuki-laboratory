module WithBreadcrumbs
  def exercise_breadcrumb(e)
    base = link_to_exercise e, plain: true
    if e.guide
      "#{guide_breadcrumb(e.guide)} <li>#{base}</li>".html_safe
    else
      base
    end
  end

  def guide_breadcrumb(g)
    base = link_to_guide g, plain: true
    if g.chapter
      "#{path_breadcrumb(g.chapter)} <li>#{base}</li>".html_safe
    else
      base
    end
  end

  def path_breadcrumb(p)
    "<li>#{link_to_chapter p}</li>".html_safe
  end
end
