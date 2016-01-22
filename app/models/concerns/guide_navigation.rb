module GuideNavigation
  extend ActiveSupport::Concern

  included do
    has_one :chapter_guide
    has_one :chapter, through: :chapter_guide
  end

  def positionate!(chapter, number) #FIXME stop doing position logic by hand
    self.chapter_guide = ChapterGuide.new chapter: chapter, number: number, guide: self
    self.chapter = chapter
    self.chapter_guide
  end

  def done_for?(user)
    stats_for(user).done?
  end

  def number
    chapter_guide.try(&:number)
  end

  def siblings_for(user)
    chapter.defaulting([]) { |it| it.pending_guides(user) }
  end

  def siblings
    chapter.defaulting([], &:guides)
  end

  def parent
    chapter
  end

end
