class Tenant < ActiveRecord::Base
  validates_presence_of :name, :locale

  def switch!
    Apartment::Tenant.switch! name
  end

  def destroy!
    super
    begin
      Apartment::Tenant.drop name
    rescue Apartment::TenantNotFound => _e
      Rails.logger.warn("Tenant #{name} not found")
    end
  end

  def self.create!(args)
    transaction do
      tenant = super(args)
      Apartment::Tenant.create args[:name]
      tenant
    end
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
end
