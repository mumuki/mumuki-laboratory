module LinksRendering
  def link_to_exercise(exercise)
    link_to exercise.title, exercise
  end

  def link_to_language(language)
    link_to language.name, language
  end

  def link_to_guide(guide)
    link_to guide.name, guide
  end

  def link_to_github(guide)
    link_to guide.github_repository, guide.github_url
  end

end