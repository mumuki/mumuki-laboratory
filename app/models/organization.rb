class Organization < ActiveRecord::Base
  belongs_to :book

  delegate :locale, to: :book

  before_create :setup_apartment_tenant!
  after_destroy :teardown_apartment_tenant!

  validates_presence_of :name, :contact_email
  validates_uniqueness_of :name

  def switch!
    Apartment::Tenant.switch! name
  end

  def self.current
    raise 'book not selected' if Apartment::Tenant.on? 'public'
    find_by name: Apartment::Tenant.current
  end

  def self.central
    find_by name: 'central'
  end

  def self.central?
    current.central?
  end

  def central?
    name == 'central'
  end

  def test?
    name == 'test'
  end

  def silent?
    central? || test?
  end

  private

  def teardown_apartment_tenant!
    Apartment::Tenant.teardown name
  end

  def setup_apartment_tenant!
    Apartment::Tenant.setup name
  end

end
