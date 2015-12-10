module WithLinksRendering
  def link_to_exercise(exercise, options={})
    name = extract_name exercise, options
    link_to name, exercise, options
  end

  def link_to_guide(guide, options={})
    name = extract_name guide, options
    link_to name, guide, options
  end

  def link_to_user(user)
    link_to user.name, user
  end

  def link_to_chapter(chapter)
    link_to chapter.name, chapter
  end

  private

  def extract_name(named, options)
    plain = options.delete(:plain)
    plain ? named.name : named.friendly
  end
end
