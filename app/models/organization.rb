class Organization < ActiveRecord::Base
  include Mumukit::Platform::OrganizationHelpers

  serialize :community, Mumukit::Platform::Community
  serialize :settings, Mumukit::Platform::Settings
  serialize :theme, Mumukit::Platform::Theme

  validate :ensure_consistent_public_login

  belongs_to :book
  has_many :usages

  validates_presence_of :name, :contact_email
  validates_uniqueness_of :name

  after_create :reindex_usages!
  after_save :notify!

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
      book.index_usage! self
      exams.each { |exam| exam.index_usage! self }
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

  def notify!
    Mumukit::Nuntius.notify_event! 'OrganizationChanged', event_json
  end

  def event_json
    { name: name, book_ids: book_slugs, book_id: book.slug, lock_json: login_settings.lock_json }
      .merge(theme.as_json)
      .merge(settings.as_json)
      .merge(community.as_json)
  end

  def book_slugs
    book_ids.map { |id| Book.find(id).slug }
  end

  private

  def ensure_consistent_public_login
    errors.add(:base, :consistent_public_login) if customized_login_methods? && public?
  end

  def notify_assignments!(assignments)
    puts "We will try to send #{assignments.count} assignments, please wait..."
    assignments.each { |assignment| assignment.notify! }
  end

  class << self
    def central
      find_by name: 'central'
    end

    def create_from_json!(json)
      Organization.create! parse_json json
    end

    def update_from_json!(json)
      organization_json = parse_json json

      organization = Organization.find_by! name: organization_json[:name]
      organization.update! organization_json
    end

    def parse_json(json)
      book_ids = json[:books].map { |it| Book.find_by!(slug: it).id }
      json
        .slice(:name)
        .merge(book_id: book_ids.first, book_ids: book_ids)
        .merge(theme: Mumukit::Platform::Theme.parse(json))
        .merge(settings: Mumukit::Platform::Settings.parse(json))
        .merge(community: Mumukit::Platform::Community.parse(json))
    end
  end
end
