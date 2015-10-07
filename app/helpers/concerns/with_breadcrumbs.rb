module WithBreadcrumbs
  def exercise_breadcrumb(e)
    base = link_to_exercise e, plain: true
    if e.guide
      "#{guide_breadcrumb(e.guide)}/#{base}".html_safe
    else
      base
    end
  end

  def guide_breadcrumb(g)
    base = link_to_guide g, plain: true
    if g.path
      "#{path_breadcrumb(g.path)}/#{base}".html_safe
    else
      base
    end
  end

  def path_breadcrumb(p)
    link_to_path p
  end
end
