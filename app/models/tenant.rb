class Tenant < ActiveRecord::Base
  validates_presence_of :name, :locale

  before_create :setup_apartment_tenant!
  after_destroy :teardown_apartment_tenant!

  def switch!
    Apartment::Tenant.switch! name
  end

  def self.on_public?
    on? 'public'
  end

  def self.on_central?
    on? 'central'
  end

  def self.on?(name)
    Apartment::Tenant.current == name
  end

  def self.current
    raise 'tenant not selected' if on_public?
    find_by name: Apartment::Tenant.current
  end

  def self.central
    find_by name: 'central'
  end

  private

  def teardown_apartment_tenant!
    Apartment::Tenant.drop name
  rescue Apartment::TenantNotFound => _e
    Rails.logger.warn("Tenant #{name} not found")
  end

  def setup_apartment_tenant!
    Apartment::Tenant.create name
  end
end
