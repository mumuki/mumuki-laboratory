class Guide < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name, :description],
      associated_against: {
          language: [:name]
      }
  }

  include WithSearch, WithAuthor,
          WithMarkup,
          WithTeaser, WithLocale

  #TODO rename name to title. This helps building also generic link_to compoenetns
  has_many :exercises, -> { order(position: :asc) }
  has_many :imports, -> { order(created_at: :desc)}
  has_many :exports

  has_and_belongs_to_many :contributors, class_name: 'User', join_table: 'contributors'
  has_and_belongs_to_many :collaborators, class_name: 'User', join_table: 'collaborators'

  has_and_belongs_to_many :suggested_guides,
                          class_name: 'Guide',
                          join_table: 'suggested_guides',
                          association_foreign_key: 'suggested_guide_id'

  belongs_to :language

  validates_presence_of :github_repository, :name, :author

  markup_on :description, :teaser

  def exercises_count
    exercises.count
  end

  def pending_exercises(user)
    exercises.
        at_locale.
        joins("left join submissions
                on submissions.exercise_id = exercises.id
                and submissions.submitter_id = #{user.id}
                and submissions.status = #{Submission.passed_status}").
        where('submissions.id is null')
  end

  def next_exercise(user)
    pending_exercises(user).order('exercises.original_id asc').first
  end

  #TODO denormalize
  def search_tags
    exercises.flat_map(&:search_tags).uniq
  end

  #TODO denormalize
  def tag_list
    exercises.flat_map(&:tag_list).uniq.join(', ')
  end

  def stats(user)
    Stats.from_statuses exercises.map { |it| it.status_for(user) }
  end

  def github_url
    "https://github.com/#{github_repository}"
  end

  def github_repository_name
    github_repository.split('/')[1]
  end

  def format_original_id(exercise)
    original_id_format % exercise.original_id
  end

  def update_contributors!
    self.contributors = user_resources_to_users author.contributors(self)
    save!
  end

  def update_collaborators!
    self.collaborators = user_resources_to_users author.collaborators(self)
    save!
  end

  def collaborator?(user)
    collaborators.include? user
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
