class Organization < ActiveRecord::Base
  include Mumukit::Platform::Organization::Helpers

  serialize :profile, Mumukit::Platform::Organization::Profile
  serialize :settings, Mumukit::Platform::Organization::Settings
  serialize :theme, Mumukit::Platform::Organization::Theme

  validate :ensure_consistent_public_login

  numbered :units
  has_many :units
  has_many :usages

  validates_presence_of :name, :contact_email
  validates_uniqueness_of :name

  after_create :reindex_usages!

  has_many :books, through: 'units', source: 'book'
  has_many :guides, through: 'usages', source: 'item', source_type: 'Guide'
  has_many :exercises, through: :guides
  has_many :assignments, through: :exercises
  has_many :exams


  def in_path?(item)
    usages.exists?(item: item) || usages.exists?(parent_item: item)
  end

  def notify_recent_assignments!(date)
    notify_assignments! assignments.where('assignments.updated_at > ?', date)
  end

  def notify_assignments_by!(submitter)
    notify_assignments! assignments.where(submitter_id: submitter.id)
  end

  def silent?
    test?
  end

  def reindex_usages!
    transaction do
      drop_usage_indices!
      [units, exams].flatten.each &:index_usage!
    end
  end

  def drop_usage_indices!
    usages.destroy_all
  end

  def index_usage_of!(item, parent)
    Usage.create! organization: self, item: item, parent_item: parent
  end

  def accessible_exams_for(user)
    exams.select { |exam| exam.accessible_for?(user) }
  end

  def first_book
    first_unit.book
  end

  def first_unit
    units.first
  end

  def import_from_json!(json)
    self.assign_attributes self.class.parse(json)

    if json[:books].present?
      units = json[:books].map { |it| Book.find_by!(slug: it).as_unit_of(self) }
    else
      units = json[:units].map do |it|
        unit = Book.find_by!(slug: it[:book]).as_unit_of(self)
        unit.rebuild! projects: it[:projects].map { |it|  Guide.find_by!(slug: it).as_project_of(unit) }
        unit.rebuild! complements: it[:complements].map { |it| Guide.find_by!(slug: it).as_complement_of(unit) }
      end
    end

    rebuild! units: units
    reindex_usages!
  end

  private

  def ensure_consistent_public_login
    errors.add(:base, :consistent_public_login) if settings.customized_login_methods? && public?
  end

  def notify_assignments!(assignments)
    puts "We will try to send #{assignments.count} assignments, please wait..."
    assignments.each { |assignment| assignment.notify! }
  end


  class << self
    def central
      find_by name: 'central'
    end

    def import_from_json!(json)
      json = json.deep_symbolize_keys
      prepare_by(name: json[:name]) { |it| it.import_from_json! json }
    end
  end
end
