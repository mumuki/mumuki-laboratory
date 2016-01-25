module WithNavigation
  def next_button(navigable)
    ContinueNavigation.new(self).button(navigable) || RevisitNavigation.new(self).button(navigable)
  end
end
