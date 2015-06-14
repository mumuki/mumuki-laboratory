module LinksRendering
  def link_to_exercise(exercise)
    link_to exercise.title, exercise
  end

  def link_to_language(language)
    link_to language.name, language
  end

  def link_to_guide(guide, options={})
    link_to with_classifications(guide), guide, options
  end

  def link_to_github(guide)
    link_to guide.github_repository, guide.github_url
  end

  def link_to_user(user)
    link_to user.name, user
  end

end
