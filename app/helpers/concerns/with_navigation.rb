module WithNavigation
  def next_button(navigable)
    ContinueNavigation.new(self).button(navigable) || RevisitNavigation.new(self).button(navigable)
  end

  def next_nav_button(navigable)
    ForwardNavigation.new(self).button(navigable)
  end

  def previous_nav_button(navigable)
    BackwardNavigation.new(self).button(navigable)
  end
end
