module GuideNavigation
  extend ActiveSupport::Concern

  included do
    has_one :lesson #FIXME
    has_one :topic, through: :lesson
  end

  def positionate!(chapter, number) #FIXME stop doing position logic by hand
    self.lesson = Lesson.new topic: chapter.topic, number: number, guide: self
    self.topic = chapter.topic
    self.lesson
  end

  def done_for?(user)
    stats_for(user).done?
  end

  def number
    lesson.try(&:number)
  end

  def pending_siblings_for(user)
    chapter.defaulting([]) { |it| it.pending_guides(user) }
  end

  def parent
    chapter
  end

  def chapter
    Rails.logger.warn 'deprecated, remove apartement first'
    topic.try { |it| it.chapters.first } #FIXME
  end

end
