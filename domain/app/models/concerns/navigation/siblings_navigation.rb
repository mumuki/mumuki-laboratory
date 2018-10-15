module SiblingsNavigation

  def next_for(user)
    pending_siblings_for(user).select { |it| it.number > number }.sort_by(&:number).first
  end

  def restart(user)
    pending_siblings_for(user).sort_by(&:number).first
  end

  # Names

  def navigable_name
    "#{number}. #{name}"
  end

  # Answers a - maybe empty - list of pending siblings for the given user
  #required :pending_siblings_for
end
