module WithLinksRendering
  def link_to_exercise(exercise)
    link_to exercise.name, exercise
  end

  def link_to_guide(guide, options={})
    link_to (raw guide.name), guide, options
  end

  def link_to_github(guide)
    link_to guide.github_repository, guide.github_url
  end

  def link_to_user(user)
    link_to user.name, user
  end

  def link_to_path(path)
    link_to path.name, path
  end
end
