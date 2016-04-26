module GuideNavigation
  extend ActiveSupport::Concern

  included do
    has_one :lesson
    has_one :chapter, through: :lesson
  end

  def positionate!(chapter, number) #FIXME stop doing position logic by hand
    self.lesson = Lesson.new chapter: chapter, number: number, guide: self
    self.chapter = chapter
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

end
