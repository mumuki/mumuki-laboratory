class Exercise < ActiveRecord::Base
  include WithMarkup

  enum language: Plugins::LANGUAGES

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

  def plugin
    #FIXME move to Plugins
    Kernel.const_get("#{language.to_s.titleize}Plugin".to_sym).new
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
    submissions.select {|s| s.submitter_id == user.id }.last.content
  end

  private

  def defaults
    self.submissions_count = 0
  end
end
