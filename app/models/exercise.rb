class Exercise < ActiveRecord::Base
  include PgSearch

  include WithMarkup
  include WithAuthor

  belongs_to :language
  belongs_to :guide

  before_destroy :can_destroy?

  has_many :submissions

  acts_as_taggable

  validates_presence_of :title, :description, :language, :test,
                        :submissions_count, :author, :locale
  after_initialize :defaults, if: :new_record?

  pg_search_scope :full_text_search,
                  against: [:title, :description],
                  associated_against: {language: [:name], tags: [:name]},
                  using: {tsearch: {prefix: true}}

  scope :by_tag, lambda { |tag| tagged_with(tag) if tag.present? }
  scope :by_full_text, lambda { |q| full_text_search(q) if q.present? }

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

  def description_html
    with_markup description
  end

  def can_destroy?
    submissions_count == 0
  end

  def can_edit?
    guide.nil?
  end

  def default_content_for(user)
    submissions_for(user).last.try(&:content) || ''
  end

  def submissions_for(user)
    submissions.where(submitter_id: user.id)
  end

  def solved_by?(user)
    submissions_for(user).where("status = ?", Submission.statuses[:passed]).exists?
  end

  def submitted_by?(user)
    submissions_for(user).exists?
  end
  private

  def defaults
    self.submissions_count = 0
  end
end
