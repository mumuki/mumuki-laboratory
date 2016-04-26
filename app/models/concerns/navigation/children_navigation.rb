module ChildrenNavigation

  def enter(user)
    pending_children_for(user).sort(&:number).first
  end

  #required :pending_children
end