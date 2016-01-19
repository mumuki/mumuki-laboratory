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

  markdown_on :description, :hint, :teaser, :corollary

  def search_tags
    tag_list + [language.name]
  end

  def extra
    [guide.extra, self[:extra]].compact.join("\n")
  end

  def friendly
    with_parent_name { "#{parent.friendly} - #{name}" }
  end

  def new_solution
    Solution.new(content: default_content)
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
