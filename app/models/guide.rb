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
          WithPath,
          WithExercises,
          WithStats,
          WithExpectations,
          Slugged

  has_many :imports, -> { order(created_at: :desc) }
  has_many :exports

  has_and_belongs_to_many :contributors, class_name: 'User', join_table: 'contributors'

  belongs_to :language

  validates_presence_of :url

  markup_on :description, :teaser, :corollary

  has_one :path_rule
  
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

  def slugged_name
    with_parent_name { "#{parent.slugged_name}: #{name}" }
  end

  def position
    path_rule.try(&:position)
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
