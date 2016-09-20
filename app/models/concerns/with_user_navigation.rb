module WithUserNavigation
  def navigable_name
    name
  end

  def navigation_end?
    true
  end
end
