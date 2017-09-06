class Chapter < Container
  include WithStats
  include WithNumber

  belongs_to :book
  belongs_to :topic

  delegate :appendix,
           :appendix_html,
           :rebuild!,
           :lessons,
           :guides,
           :pending_guides,
           :lessons,
           :first_lesson,
           :exercises, to: :topic

  include SiblingsNavigation
  include ParentNavigation

  alias_method :unit, :navigable_parent

  def structural_parent
    book
  end

  def child
    topic
  end

  def pending_siblings_for(user)
    book.pending_chapters(user) # FIXME broken. Use progress
  end

  def index_usage_at!(organization)
    super
    topic.lessons.each { |lesson| lesson.index_usage_at! organization }
  end

end
