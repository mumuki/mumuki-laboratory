class Tenant < ActiveRecord::Base
  validates_presence_of :name, :locale

  def switch!
    Apartment::Tenant.switch! name
  end

  def destroy!
    transaction do
      super
      Apartment::Tenant.drop name
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
    Apartment::Tenant.current == 'public'
  end

  def self.current
    raise 'tenant not selected' if on_public?
    find_by name: Apartment::Tenant.current
  end
end
