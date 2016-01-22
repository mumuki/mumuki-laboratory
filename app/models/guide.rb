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
          FriendlyName

  include WithParent, Navigable, GuideNavigation

  belongs_to :language

  validates_presence_of :slug

  markdown_on :description, :teaser, :corollary

  has_one :chapter_guide

  self.inheritance_column = nil

  enum type: [ :learning, :practice ]

  #TODO denormalize
  def search_tags
    exercises.flat_map(&:search_tags).uniq
  end

  def new?
    created_at > 7.days.ago
  end

  def friendly
    with_parent_name { "#{parent.friendly}: #{name}" }
  end

  def import!
    import_from_json! Mumukit::Bridge::Bibliotheca.new.guide(slug)
  end

  def import_from_json!(json)
    self.assign_attributes json.except('exercises', 'language', 'id_format', 'id')
    self.language = Language.for_name(json['language'])
    self.save!

    json['exercises'].each_with_index do |e, i|
      number = i + 1
      exercise = Exercise.class_for(e['type']).find_or_initialize_by(number: number, guide_id: self.id)
      exercise.import_from_json! e
    end
    reload
  end

end
