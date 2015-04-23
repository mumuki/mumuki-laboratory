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
          WithSubmissions, WithGuide, WithLocale

  acts_as_taggable

  belongs_to :language

  has_many :expectations

  accepts_nested_attributes_for :expectations, reject_if: :all_blank, allow_destroy: true

  before_destroy :can_destroy?
  after_initialize :defaults, if: :new_record?

  validates_presence_of :title, :description, :language, :test,
                        :submissions_count, :author, :locale
  validates_presence_of :position, if: :guide

  scope :by_tag, lambda { |tag| tagged_with(tag) if tag.present? }

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
    true #TODO remove this method
  end

  def search_tags
    tag_list + [language.name] + (guide.try(&:name) || [])
  end

  def generate_original_id!
    update!(original_id: id) unless original_id
  end

  def contextualized_title
    if guide
      "#{position}. #{title}"
    else
      title
    end
  end

  private

  def defaults
    self.submissions_count = 0
  end
end
