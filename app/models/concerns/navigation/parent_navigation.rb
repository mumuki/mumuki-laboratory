module ParentNavigation

  def leave(user)
    navigable_parent.next_for(user)
  end

  def navigation_end?
    false
  end

  def navigable_name
    defaulting_name { super }
  end

  def navigable_parent
    structural_parent.usage_in_organization
  end

  #required :structural_parent

  private

  def defaulting_name(&block)
    navigable_parent.defaulting(name, &block)
  end
end

