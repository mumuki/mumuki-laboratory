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
          FriendlyName,
          WithLanguage

  include Submittable,
          Questionable

  include SiblingsNavigation,
          ParentNavigation

  scope :currently_used, -> (q='') { by_full_text(q).order('submissions_count desc').select(&:used_in?) }

  belongs_to :guide

  after_initialize :defaults, if: :new_record?

  validates_presence_of :name, :description,
                        :submissions_count,
                        :guide

  markdown_on :description,
              :teaser

  def used_in?(organization=Organization.current)
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
    [language&.name, *tag_list].compact
  end

  def slug
    "#{guide.slug}/#{bibliotheca_id}"
  end

  def slug_parts
    guide.slug_parts.merge(bibliotheca_id: bibliotheca_id)
  end

  def friendly
    defaulting_name { "#{navigable_parent.friendly} - #{name}" }
  end

  def new_solution
    Solution.new(content: default_content)
  end

  def import_from_json!(number, json)
    self.language = Language.for_name(json['language']) || guide.language
    self.locale = guide.locale

    reset!

    attrs = json.except('type', 'id', 'solution', 'language', 'teacher_info', 'choices')
    attrs['choices'] = json['choices'].map { |choice| choice['value'] } if json['choices'].present?
    attrs['bibliotheca_id'] = json['id']
    attrs['number'] = number
    attrs = attrs.except('expectations') if json['type'] == 'playground' || json['new_expectations']

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

  def messages_path_for(user)
    "api/guides/#{guide.slug}/#{user.uid}/#{bibliotheca_id}/messages?language=#{language}"
  end

  def messages_url_for(user)
    Mumukit::Platform.classroom_api.organic_url_for(Organization.current, messages_path_for(user))
  end

  private

  def defaults
    self.submissions_count = 0
  end


  def self.class_for(type)
    type.camelcase.constantize
  end

  def self.default_layout
    layouts.keys[0]
  end
end
