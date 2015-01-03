class Exercise < ActiveRecord::Base
  include WithMarkup

  belongs_to :language
  belongs_to :author, class_name: 'User'
  belongs_to :guide

  before_destroy :can_destroy?

  has_many :submissions

  acts_as_taggable

  validates_presence_of :title, :description, :language, :test,
                        :submissions_count, :author
  after_initialize :defaults, if: :new_record?

  scope :by_tag, lambda { |tag| tagged_with(tag) if tag.present? }


  def self.create_or_update_for_import!(guide, original_id, options)
    exercise = find_or_initialize_by(original_id: original_id, guide_id: guide.id)
    exercise.assign_attributes(options)
    exercise.save!
  end

  def authored_by?(user)
    user == author
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
    submissions_for(user).where("status = ?", Submission.statuses[:passed]).count > 0
  end

  private

  def defaults
    self.submissions_count = 0
  end
end
