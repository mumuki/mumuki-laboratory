class Guide < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:name, :description],
  }

  include WithSearch
  include WithAuthor

  #TODO rename name to title. This helps building also generic link_to compoenetns
  has_many :exercises
  has_many :imports

  validates_presence_of :github_repository, :name, :author, :description
  validate :valid_name?

  def valid_name?
    errors.add(:name, 'can not contain whitespaces') if name && name =~ /\s+/
  end

  def exercises_count
    exercises.count
  end

  def next_exercise(user, &extra)
    candidates = exercises.
        at_locale.
        joins("left join submissions
                on submissions.exercise_id = exercises.id
                and submissions.submitter_id = #{user.id}
                and submissions.status = #{Submission.statuses[:passed]}").
        where('submissions.id is null')

    candidates = extra.call(candidates) if block_given?

    candidates.order('RANDOM()').first
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

  def stats(user)
    Stats.from_statuses exercises.map { |it| it.status_for(user) }
  end

  #TODO move to DB
  def self.at_locale
    select { |it| it.locale == I18n.locale.to_s }
  end
end
