module OnChapter
  extend ActiveSupport::Concern

  included do
    include WithSiblings

    has_one :chapter_guide
    has_one :chapter, through: :chapter_guide
  end

  def positionate!(chapter, position)
    self.chapter_guide = ChapterGuide.new chapter: chapter, position: position, guide: self
    self.chapter = chapter
    self.chapter_guide
  end

  def position
    chapter_guide.try(&:position)
  end

  def siblings_for(user)
    chapter.pending_guides(user)
  end

  def siblings
    chapter.guides
  end

  def parent
    chapter
  end

end
