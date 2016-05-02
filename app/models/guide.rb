class Guide < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name, :description],
      associated_against: {
          language: [:name]
      }
  }

  include WithSearch,
          WithTeaser,
          WithLocale,
          WithStats,
          WithExpectations,
          WithLanguage

  include ChildrenNavigation

  validates_presence_of :slug

  markdown_on :description, :teaser, :corollary

  numbered :exercises
  has_many :exercises, -> { order(number: :asc) }, dependent:  :delete_all
  has_many :usages, as: :item

  self.inheritance_column = nil

  enum type: [:learning, :practice]

  def lesson
    #FIXME temporary
    usage_in_organization
  end

  def chapter
    lesson.chapter #FIXME temporary
  end

  def usage_in_organization
    Lesson.where(guide_id: id).first #FIXME use usages and consider exams and complements
  end

  def pending_exercises(user)
    exercises.
        joins("left join public.assignments assignments
                on assignments.exercise_id = exercises.id
                and assignments.submitter_id = #{user.id}
                and assignments.status = #{Status::Passed.to_i}").
        where('assignments.id is null')
  end

  def next_exercise(user)
    pending_exercises(user).order('public.exercises.number asc').first
  end

  def first_exercise
    exercises.first
  end

  #TODO denormalize
  def search_tags
    exercises.flat_map(&:search_tags).uniq
  end

  #TODO use mumukit slug
  def org_and_repo
    org, repo = slug.split('/')
    {organization: org, repository: repo}
  end

  def done_for?(user)
    stats_for(user).done?
  end

  def import!
    import_from_json! Mumukit::Bridge::Bibliotheca.new.guide(slug)
  end

  def import_from_json!(json)
    self.assign_attributes json.except('exercises', 'language', 'id_format', 'id', 'teacher_info')
    self.language = Language.for_name(json['language'])
    self.save!

    json['exercises'].each_with_index do |e, i|
      exercise = Exercise.find_by(guide_id: self.id, bibliotheca_id: e['id'])

      exercise = exercise ?
          exercise.ensure_type!(e['type']) :
          Exercise.class_for(e['type']).new(guide_id: self.id, bibliotheca_id: e['id'])

      exercise.import_from_json! (i+1), e
    end

    reload
  end

end
