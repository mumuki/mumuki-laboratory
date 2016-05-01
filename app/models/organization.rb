class Organization < ActiveRecord::Base
  belongs_to :book

  delegate :locale, to: :book

  before_create :setup_apartment_tenant!
  after_destroy :teardown_apartment_tenant!

  validates_presence_of :name
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
    current.name == 'central'
  end

  private

  def teardown_apartment_tenant!
    Apartment::Tenant.teardown name
  end

  def setup_apartment_tenant!
    Apartment::Tenant.setup name
  end

end
