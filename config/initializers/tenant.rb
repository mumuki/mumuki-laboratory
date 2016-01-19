module Apartment::Tenant
  def self.exists?(name)
    Apartment.connection.schema_exists? name
  end

  def self.on?(name)
    current == name
  end

  def teardown(name)
    drop(name) unless exists? name
  end

  def setup(name)
    create(name) unless exists? name
  end
end