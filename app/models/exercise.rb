class Exercise < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {

      against: [:name, :description, :tag_list],
      associated_against: {
          language: [:name],
          guide: [:name]
      },
  }

  include WithSearch,
          WithTeaser,
          WithMarkup,
          WithAuthor,
          WithAssignments,
          OnGuide,
          WithLocale,
          WithLanguage,
          WithLayout,
          Submittable,
          Queriable,
          Slugged

  after_initialize :defaults, if: :new_record?

  validates_presence_of :name, :description, :language,
                        :submissions_count

  markup_on :description, :hint, :teaser, :corollary

  def search_tags
    tag_list + [language.name]
  end

  def generate_original_id!
    update!(original_id: id) unless original_id
  end

  def collaborator?(user)
    guide.present? && guide.authored_by?(user)
  end

  def extra_code
    [guide.try(&:extra), self[:extra_code]].compact.join("\n")
  end

  def slugged_name
    with_parent_name { "#{parent.slugged_name} - #{name}" }
  end

  private

  def defaults
    self.submissions_count = 0
    self.layout = Exercise.default_layout
  end

  def self.class_for(type)
    Kernel.const_get(type.camelcase)
  end

  def self.default_layout
    layouts.keys[0]
  end
end
