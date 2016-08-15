class Book < ActiveRecord::Base
  validates_presence_of :name, :locale

  include WithSlug

  numbered :chapters
  aggregate_of :chapters

  has_many :chapters, -> { order(number: :asc) }, dependent: :delete_all
  has_many :complements, dependent: :delete_all

  markdown_on :description

  def first_chapter
    chapters.first
  end

  def first_exercise
    first_chapter.first_lesson.first_exercise
  end

  def next_exercise_for(user)
    user.try(&:last_exercise) || first_exercise
  end

  def import_from_json!(json)
    self.assign_attributes json.except('chapters', 'complements', 'id', 'description', 'teacher_info')
    self.description = json['description'].squeeze(' ')

    rebuild! json['chapters'].map { |it| Topic.find_by!(slug: it).as_chapter_of(self) }
    rebuild_complements!  (json['complements']||[]).map { |it| Guide.find_by!(slug: it).as_complement_of(self) }

    Organization.all.each { |org| org.reindex_usages! }
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
end
