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
          WithAssignments,
          OnGuide,
          WithLocale,
          WithLanguage,
          WithLayout,
          Submittable,
          Queriable,
          FriendlyName

  after_initialize :defaults, if: :new_record?

  validates_presence_of :name, :description, :language,
                        :submissions_count, :guide

  markup_on :description, :hint, :teaser, :corollary

  def search_tags
    tag_list + [language.name]
  end

  def generate_original_id!
    update!(original_id: id) unless original_id
  end

  def extra_code
    [guide.extra, self[:extra_code]].compact.join("\n")
  end

  def friendly
    with_parent_name { "#{parent.friendly} - #{name}" }
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
