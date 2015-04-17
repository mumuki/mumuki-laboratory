class Guide < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name, :description],
  }

  include WithSearch, WithAuthor,
          WithWebHook, WithMarkup,
          WithTeaser

  #TODO rename name to title. This helps building also generic link_to compoenetns
  has_many :exercises
  has_many :imports
  has_many :exports

  validates_presence_of :github_repository, :name, :author, :description
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

  #TODO normalize
  def language
    exercises.first.language rescue nil
  end

  #TODO denormalize
  def search_tags
    exercises.flat_map(&:search_tags).uniq
  end

  #TODO denormalize
  def tag_list
    exercises.flat_map(&:tag_list).uniq.join(', ')
  end

  #TODO normalize
  def locale
    exercises.first.locale rescue nil
  end

  def github_url
    "https://github.com/#{github_repository}"
  end

  def github_authorized_url(user)
    "https://#{user.token}:@github.com/#{github_repository}"
  end

  def stats(user)
    Stats.from_statuses exercises.map { |it| it.status_for(user) }
  end

  def github_repository_name
    github_repository.split('/')[1]
  end

  #TODO move to DB
  def self.at_locale
    select { |it| it.locale == I18n.locale.to_s }
  end

  def format_original_id(exercise)
    original_id_format % exercise.original_id
  end

end
