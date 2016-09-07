class Exercise < ActiveRecord::Base
  INDEXED_ATTRIBUTES = {

      against: [:name, :description, :tag_list],
      associated_against: {
          language: [:name],
          guide: [:name]
      },
  }

  include WithNumber,
          WithSearch,
          WithTeaser,
          WithAssignments,
          WithLocale,
          WithLanguage,
          WithLayout,
          FriendlyName

  include Submittable, Queriable
  include SiblingsNavigation, ParentNavigation

  belongs_to :guide

  after_initialize :defaults, if: :new_record?

  validates_presence_of :name, :description, :language,
                        :submissions_count, :guide

  markdown_on :description, :hint, :teaser, :corollary, :extra_preview

  delegate :stateful_console?, to: :language

  def used_in?(organization)
    guide.usage_in_organization(organization).present?
  end

  def pending_siblings_for(user)
    guide.pending_exercises(user)
  end

  def structural_parent
    guide
  end

  def guide_done_for?(user)
    guide.done_for?(user)
  end

  def previous
    guide.exercises.find_by(number: number.pred)
  end

  def search_tags
    tag_list + [language.name]
  end

  def slug
    "#{guide.slug}/#{bibliotheca_id}"
  end

  def extra
    extra_code = [guide.extra, self[:extra]].compact.join("\n")
    if extra_code.empty? or extra_code.end_with? "\n"
      extra_code
    else
      "#{extra_code}\n"
    end

  end

  def friendly
    defaulting_name { "#{navigable_parent.friendly} - #{name}" }
  end

  def new_solution
    Solution.new(content: default_content)
  end

  def extra_preview
    "```#{language.name}\n#{extra}```"
  end

  def import_from_json!(number, json)
    self.language = Language.for_name(json['language']) || guide.language
    self.locale = guide.locale

    reset!

    attrs = json.except('type', 'id', 'solution', 'language', 'teacher_info')
    attrs['bibliotheca_id'] = json['id']
    attrs['number'] = number
    attrs = attrs.except('expectations') if json['type'] == 'playground' || json['new_expectations'] #FIXME bug in bibliotheca

    assign_attributes(attrs)
    save!
  end

  def reset!
    self.name = nil
    self.description = nil
    self.corollary = nil
    self.hint = nil
    self.extra = nil
    self.layout = self.class.default_layout
    self.tag_list = []
  end

  def ensure_type!(type)
    if self.type != type
      reclassify! type
    else
      self
    end
  end


  def reclassify!(type)
    update!(type: Exercise.class_for(type).name)
    Exercise.find(id)
  end

  private

  def defaults
    self.submissions_count = 0
    self.layout = self.class.default_layout
  end


  def self.class_for(type)
    Kernel.const_get(type.camelcase)
  end

  def self.default_layout
    layouts.keys[0]
  end
end
