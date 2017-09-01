module ParentNavigation

  def leave(user)
    navigable_parent.next_for(user)
  end

  def navigation_end?
    navigable_parent.blank?
  end

  def navigable_name
    name
  end

  def navigable_parent
    structural_parent.usage_in_organization
  end

  #required :structural_parent

  def friendly
    defaulting_name { |parent| "#{parent.friendly} - #{name}" }
  end

  private

  def defaulting_name(&block)
    navigable_parent.defaulting(name, &block)
  end
end

