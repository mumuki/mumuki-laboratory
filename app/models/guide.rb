class Guide < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name, :description],
  }

  include WithSearch, WithAuthor,
          WithMarkup,
          WithTeaser, WithLocale

  #TODO rename name to title. This helps building also generic link_to compoenetns
  has_many :exercises, -> { order(position: :asc) }
  has_many :imports, -> { order(created_at: :desc)}
  has_many :exports

  belongs_to :language

  validates_presence_of :github_repository, :name, :author
  validates_uniqueness_of :name
  validate :valid_name?

  markup_on :description, :teaser

  def valid_name?
    errors.add(:name, 'can not contain whitespaces') if name && name =~ /\s+/
  end

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

end
