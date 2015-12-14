class Guide < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name, :description],
      associated_against: {
          language: [:name]
      }
  }

  include WithSearch,
          WithMarkup,
          WithTeaser,
          WithLocale,
          OnChapter,
          WithExercises,
          WithStats,
          WithExpectations,
          FriendlyName

  has_many :imports, -> { order(created_at: :desc) }
  has_many :exports

  belongs_to :language

  validates_presence_of :slug

  markup_on :description, :teaser, :corollary

  has_one :chapter_guide

  def import!
    imports.create!
  end

  #TODO denormalize
  def search_tags
    exercises.flat_map(&:search_tags).uniq
  end

  def new?
    created_at > 7.days.ago
  end

  def done_for?(user)
    stats_for(user).done?
  end

  def friendly
    with_parent_name { "#{parent.friendly}: #{name}" }
  end

  def position
    chapter_guide.try(&:position)
  end

  def import_from_json!(json)
    self.assign_attributes json.except('exercises', 'language', 'original_id_format')
    self.language = Language.for_name(json['language'])
    self.save!

    json['exercises'].each_with_index do |e, i|
      position = i + 1
      exercise = Exercise.class_for(e['type']).find_or_initialize_by(position: position, guide_id: self.id)
      exercise.position = position
      exercise.assign_attributes(e.except('type'))
      exercise.language = self.language
      exercise.locale = self.locale
      exercise.save!
    end
  end

end
