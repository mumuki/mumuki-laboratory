class Book < Content
  numbered :chapters
  aggregate_of :chapters

  has_many :chapters, -> { order(number: :asc) }, dependent: :delete_all
  has_many :complements, dependent: :delete_all

  has_many :exercises, through: :chapters
  has_many :discussions, through: :exercises

  delegate :first_lesson, to: :first_chapter

  def to_s
    slug
  end

  def first_chapter
    chapters.first
  end

  def next_lesson_for(user)
    user.try(:last_lesson)|| first_lesson
  end

  def import_from_resource_h!(resource_h)
    self.assign_attributes resource_h.except(:chapters, :complements, :id, :description)
    self.description = resource_h[:description]&.squeeze(' ')

    rebuild! resource_h[:chapters].map { |it| Topic.find_by!(slug: it).as_chapter_of(self) }
    rebuild_complements! resource_h[:complements].to_a.map { |it| Guide.find_by(slug: it)&.as_complement_of(self) }.compact

    Organization.where(book: self).each { |org| org.reindex_usages! }
  end

  def to_resource_h
    super.merge(
      chapters: chapters.map(&:slug),
      complements: complements.map(&:slug))
  end

  def rebuild_complements!(complements) #FIXME use rebuild
    transaction do
      self.complements.all_except(complements).delete_all
      self.update! :complements => complements
      complements.each &:save!
    end
    reload
  end

  def index_usage!(organization)
    [chapters, complements].flatten.each { |item| item.index_usage! organization }
  end

  ## Forking

  def fork_to!(organization, syncer)
    rebased_dup(organization).tap do |dup|
      dup.chapters = chapters.map { |chapter| chapter.topic.fork_to!(organization, syncer).as_chapter_of(self) }
      dup.complements = complements.map { |complement| complement.guide.fork_to!(organization, syncer).as_complement_of(self) }
      dup.save!
      syncer.export! dup
    end
  end
end
