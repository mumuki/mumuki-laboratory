class Book < Content
  numbered :chapters
  has_many :chapters, -> { order(number: :asc) }, dependent: :delete_all

  delegate :first_lesson, to: :first_chapter

  def first_chapter
    chapters.first
  end

  def next_lesson_for(user)
    user.try(:last_lesson)|| first_lesson
  end

  def import_from_json!(json)
    self.assign_attributes json.except('chapters', 'id', 'description', 'teacher_info', 'complements')
    self.description = json['description'].squeeze(' ')

    rebuild! chapters: json['chapters'].map { |it| Topic.find_by!(slug: it).as_chapter_of(self) }

    Organization.reindex_all!
  end

  def as_unit_of(organization)
    organization.units.find_by(book_id: id) || Unit.new(book: self, organization: organization)
  end
end
