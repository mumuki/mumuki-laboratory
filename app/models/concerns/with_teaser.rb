module WithTeaser
  def teaser(more_link)
    description.truncate(70, omission: more_link)
  end
end
