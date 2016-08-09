class Organization < ActiveRecord::Base
  extend ConfigurableGlobal

  belongs_to :book
  has_many :usages

  delegate :locale, to: :book

  validates_presence_of :name, :contact_email, :login_methods
  validates_uniqueness_of :name

  after_create :reindex_usages!

  has_many :guides, through: 'usages', source: 'item', source_type: 'Guide'
  has_many :exercises, through: :guides
  has_many :assignments, through: :exercises
  has_many :exams

  def in_path?(item)
    usages.exists?(item: item) || usages.exists?(parent_item: item)
  end

  def switch!
    self.class.current = self
  end

  def central?
    name == 'central'
  end

  def test?
    name == 'test'
  end

  def notify_recent_assignments!(date)
    notify! assignments.where('assignments.updated_at > ?', date)
  end

  def notify_assignments_by!(submitter)
    notify! assignments.where(submitter_id: submitter.id)
  end

  def silent?
    test?
  end

  def private?
    private
  end

  def public?
   !private
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

  def to_s
    name
  end

  def accessible_exams_for(user)
    exams.select { |exam| exam.accessible_for?(user) }
  end

  def login_settings
    @login_settings ||= Mumukit::Auth::LoginSettings.new(login_methods)
  end

  def absolute_link
    "http://#{relative_link}"
  end

  def relative_link
    "#{name}.#{Rails.configuration.domain_url}"
  end

  private

  def notify!(assignments)
    puts "We will try to send #{assignments.count} assignments, please wait..."
    assignments.each { |assignment| Event::Submission.new(assignment).notify! }
  end

  class << self
    attr_writer :current

    def current
      raise 'organization not selected' unless @current
      @current
    end

    def central
      find_by name: 'central'
    end
  end

end
