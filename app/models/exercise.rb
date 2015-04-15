class Exercise < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {
      against: [:title, :description],
      associated_against: {
          language: [:name],
          tags: [:name],
          guide: [:name]
      },
  }

  include WithSearch, WithTeaser,
          WithMarkup, WithAuthor,
          WithSubmissions, WithGuide

  acts_as_taggable

  belongs_to :language

  has_many :expectations

  accepts_nested_attributes_for :expectations, reject_if: :all_blank, allow_destroy: true

  before_destroy :can_destroy?
  after_initialize :defaults, if: :new_record?

  validates_presence_of :title, :description, :language, :test,
                        :submissions_count, :author, :locale

  scope :by_tag, lambda { |tag| tagged_with(tag) if tag.present? }
  scope :at_locale, lambda { where(locale: I18n.locale) }

  markup_on :description, :hint, :teaser

  def self.create_or_update_for_import!(guide, original_id, options)
    exercise = find_or_initialize_by(original_id: original_id, guide_id: guide.id)
    exercise.assign_attributes(options)
    exercise.save!
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

  private

  def defaults
    self.submissions_count = 0
  end
end
