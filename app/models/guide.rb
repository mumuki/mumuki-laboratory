class Guide < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name, :description],
      associated_against: {
          language: [:name]
      }
  }

  include WithSearch,
          WithAuthor,
          WithMarkup,
          WithTeaser,
          WithLocale,
          WithCollaborators,
          OnChapter,
          WithExercises,
          WithStats,
          WithExpectations,
          FriendlyName

  has_many :imports, -> { order(created_at: :desc) }
  has_many :exports

  has_and_belongs_to_many :contributors, class_name: 'User', join_table: 'contributors'

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

  def update_contributors!
    self.contributors = user_resources_to_users author.contributors(self)
    save!
  end

  def new?
    created_at > 7.days.ago
  end

  def solutions_for(current_user)
    exercises.map { |it| it.assignment_for(current_user).try &:solution }.compact
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

  def url
    "bibliotheca.mumuki.io/guides/#{slug}"
  end

  def read_from_json(json)
    self.assign_attributes json.except('exercises', 'language', 'original_id_format', 'github_repository')
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

  private

  def user_resources_to_users(resources)
    resources.
        select { |it| it[:type] = 'User' }.
        map { |it| it[:login] }.
        map { |it| User.find_by_name(it) }.
        compact
  end

end
