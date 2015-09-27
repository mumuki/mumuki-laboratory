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
          WithExpectations
          WithStats
  extend FriendlyId

  friendly_id :name, use: [:slugged, :finders]

  has_many :imports, -> { order(created_at: :desc)}
  has_many :exports

  has_and_belongs_to_many :contributors, class_name: 'User', join_table: 'contributors'

  belongs_to :language

  validates_presence_of :github_repository, :name, :author

  markup_on :description, :teaser, :corollary

  #TODO denormalize
  def search_tags
    exercises.flat_map(&:search_tags).uniq
  end

  def github_url
    "https://github.com/#{github_repository}"
  end

  def github_repository_name
    github_repo_owner_and_name[1]
  end

  def github_repository_owner
    github_repo_owner_and_name[0]
  end

  def github_repo_owner_and_name
    github_repository.split('/')
  end

  def format_original_id(exercise)
    original_id_format % exercise.original_id
  end

  def update_contributors!
    self.contributors = user_resources_to_users author.contributors(self)
    save!
  end

  def new?
    created_at > 7.days.ago
  end

  def solution_contents_for(current_user)
    exercises.map { |it| it.solution_for(current_user).try &:content }.compact
  end

  def done_for?(user)
    stats_for(user).done?
  end

  private

  def user_resources_to_users(resources)
    resources.
        select{|it| it[:type] = 'User'}.
        map {|it|it[:login]}.
        map {|it| User.find_by_name(it) }.
        compact
  end

end
