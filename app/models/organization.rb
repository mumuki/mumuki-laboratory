class Organization < ActiveRecord::Base
  belongs_to :book

  delegate :locale, to: :book

  validates_presence_of :name, :contact_email
  validates_uniqueness_of :name

  after_create :reindex_usages!

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
    notify! assignments.where('updated_at > ?', date)
  end

  def notify_assignments_by!(submitter)
    notify assignments.where(submitter_id: submitter.id)
  end


  def silent?
    central? || test?
  end

  def reindex_usages!
    transaction do
      drop_usage_indices!
      book.index_usages! self
    end
  end

  def drop_usage_indices!
    Usage.in_organization(self).destroy_all
  end

  def index_usage!(item, parent)
    Usage.create! organization: self, item: item, parent_item: parent
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

    def central?
      current.central?
    end
  end

end
