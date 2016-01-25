module SiblingsNavigation

  def next_for(user)
    siblings_for(user).select { |it| it.number > number }.sort_by(&:number).first
  end

  def previous_for(user)
    siblings_for(user).select { |it| it.number < number }.sort_by(&:number).last
  end

  def first_for(user)
    siblings_for(user).sort_by(&:number).first
  end

  # Names

  def navigable_name
    "#{number}. #{name}"
  end

  ##
  # Answers a - maybe empty - list of siblings
  #required :siblings

  ##
  # Answers a - maybe empty - list of pending siblings for the given user
  #required :siblings_for
end