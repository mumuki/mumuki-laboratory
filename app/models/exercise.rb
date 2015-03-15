class Exercise < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:title, :description],
      associated_against: {
          language: [:name],
          tags: [:name],
          guide: [:name]
      },
  }

  include PgSearch

  include WithMarkup
  include WithAuthor
  include WithSubmissions

  belongs_to :language
  belongs_to :guide

  before_destroy :can_destroy?

  acts_as_taggable

  validates_presence_of :title, :description, :language, :test,
                        :submissions_count, :author, :locale
  after_initialize :defaults, if: :new_record?

  pg_search_scope :full_text_search, INDEXED_ATTRIBUTES.merge(using: {tsearch: {prefix: true}})

  scope :by_tag, lambda { |tag| tagged_with(tag) if tag.present? }
  scope :by_full_text, lambda { |q| full_text_search(q) if q.present? }
  scope :at_locale, lambda { where(locale: I18n.locale) }

  markup_on :description
  markup_on :hint

  def self.create_or_update_for_import!(guide, original_id, options)
    exercise = find_or_initialize_by(original_id: original_id, guide_id: guide.id)
    exercise.assign_attributes(options)
    exercise.save!
  end

  def status_for(user)
    #TODO may just get the status of the last submission, or unknown, if there is no submission
    if solved_by?(user)
      :passed
    elsif submitted_by?(user)
      :failed
    else
      :unknown
    end
  end

  def can_destroy?
    can_edit? && submissions_count == 0
  end

  def can_edit?
    guide.nil?
  end

  def search_tags
    tag_list + [language.name] + (guide.try(&:name) || [])
  end

  def next_for(user)
    guide.exercises.
        at_locale.
        joins("left join submissions
                on submissions.exercise_id = exercises.id
                and submissions.submitter_id = #{user.id}").
        where('submissions.id is null and exercises.id <> :id', id: id).
        order('RANDOM()').
        first if guide
  end

  private

  def defaults
    self.submissions_count = 0
  end
end
