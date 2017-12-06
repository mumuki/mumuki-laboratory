class Organization < ActiveRecord::Base
  LOCALES = {
    en: { facebook_code: :en_US, name: 'English' },
    es: { facebook_code: :es_LA, name: 'Español' }
  }.with_indifferent_access

  store :profile, accessors: [:logo_url, :locale, :description, :contact_email, :terms_of_service, :community_link], coder: JSON
  store :settings, accessors: [:login_methods, :raise_hand_enabled, :public], coder: JSON
  store :theme, accessors: [:theme_stylesheet_url, :extension_javascript_url], coder: JSON

  validate :ensure_consistent_public_login

  belongs_to :book
  has_many :usages

  validates_presence_of :name, :contact_email
  validates_uniqueness_of :name

  after_create :reindex_usages!

  has_many :guides, through: 'usages', source: 'item', source_type: 'Guide'
  has_many :exercises, through: :guides
  has_many :assignments, through: :exercises
  has_many :exams

  def slug
    Mumukit::Auth::Slug.join_s name
  end

  def central?
    name == 'central'
  end

  def test?
    name == 'test'
  end

  def switch!
    Mumukit::Platform::Organization.switch! self
  end

  def to_s
    name
  end

  def url_for(path)
    Mumukit::Platform.application.organic_url_for(name, path)
  end

  def domain
    Mumukit::Platform.application.organic_domain(name)
  end

  def self.current
    Mumukit::Platform::Organization.current
  end

  def login_settings
    @login_settings ||= Mumukit::Login::Settings.new(login_methods)
  end

  def customized_login_methods?
    login_methods.size < Mumukit::Login::Settings.login_methods.size
  end

  def inconsistent_public_login?
    customized_login_methods? && public?
  end

  def locale_json
    LOCALES[locale].to_json
  end

  def logo_url
    @logo_url ||= 'https://mumuki.io/logo-alt-large.png'
  end

  def raise_hand_enabled?
    raise_hand_enabled
  end

  def public?
    public
  end

  def private?
    !public?
  end

  def login_methods
   settings[:login_methods] || Mumukit::Login::Settings.default_methods
  end

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
    reload
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
      Organization.create! parse json
    end

    def update_from_json!(json)
      organization_json = parse json

      organization = Organization.find_by! name: organization_json[:name]
      old_book = organization.slice(:book_id, :book_ids)
      organization.update! organization_json
      organization.reindex_usages! if old_book != organization_json.slice(:book, :book_ids)
    end

    def parse(json)
      book_ids = json[:books].map { |it| Book.find_by!(slug: it).id }

      json
        .slice(:name)
        .merge(Mumukit::Platform::Organization::Theme.parse(json).as_json) # TODO remove theme, settings and profile classes
        .merge(Mumukit::Platform::Organization::Settings.parse(json).as_json)
        .merge(Mumukit::Platform::Organization::Profile.parse(json).as_json)
        .merge(book_id: book_ids.first, book_ids: book_ids)
    end
  end
end
