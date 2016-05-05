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
          WithExercises,
          WithLanguage,
          FriendlyName

  include ParentNavigation, SiblingsNavigation, ChildrenNavigation, GuideNavigation

  validates_presence_of :slug

  markdown_on :description, :teaser, :corollary

  has_one :lesson #FIXME

  self.inheritance_column = nil

  enum type: [:learning, :practice]

  #TODO denormalize
  def search_tags
    exercises.flat_map(&:search_tags).uniq
  end

  #TODO use mumukit slug
  def org_and_repo
    org, repo = slug.split('/')
    {organization: org, repository: repo}
  end

  def new?
    created_at > 7.days.ago
  end

  def friendly
    defaulting_name { "#{parent.friendly}: #{name}" }
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
