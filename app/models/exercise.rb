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
          WithSubmissions, WithGuide,
          WithLocale

  acts_as_taggable

  belongs_to :language

  has_many :expectations

  enum layout: [:right, :bottom, :null, :scratchy]

  accepts_nested_attributes_for :expectations, reject_if: :all_blank, allow_destroy: true

  after_initialize :defaults, if: :new_record?

  validates_presence_of :title, :description, :language, :test,
                        :submissions_count, :author

  validate :language_consistent_with_guide, if: :guide

  scope :by_tag, lambda { |tag| tagged_with(tag) if tag.present? }

  markup_on :description, :hint, :teaser, :corollary

  delegate :visible_success_output, :highlight_mode, to: :language

  def self.create_or_update_for_import!(guide, original_id, options)
    exercise = find_or_initialize_by(original_id: original_id, guide_id: guide.id)
    exercise.assign_attributes(options)
    exercise.save!
  end

  def search_tags
    tag_list + [language.name]
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

  def collaborator?(user)
    guide.present? && guide.authored_by?(user)
  end

  def extra_code
    [guide.try(&:extra_code), self[:extra_code]].compact.join("\n")
  end

  private

  def language_consistent_with_guide
    errors.add(:base, :same_language_of_guide) if language != guide.language
  end

  def defaults
    self.submissions_count = 0
    self.layout = Exercise.default_layout
  end

  def self.default_layout
    layouts.keys[0]
  end
end
