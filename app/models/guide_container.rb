class GuideContainer < Container
  self.abstract_class = true

  delegate :language,
           :search_tags,
           :exercises,
           :first_exercise,
           :next_exercise,
           :stats_for,
           :exercises_count, to: :guide

  def access!(user)
  end

  def timed?
    false
  end

  def start!(user)
  end

  def child
    guide
  end
end
