RSpec.configure do |config|
  config.before(:suite) do
    Tenant.all.each(&:destroy!)
    Tenant.create!(name: 'test')
  end

  config.before(:each) do
    Tenant.find_by(name: 'test').switch!
  end

  config.after(:each) do
    Apartment::Tenant.reset
  end
end