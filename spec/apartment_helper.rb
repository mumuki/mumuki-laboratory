RSpec.configure do |config|
  config.before(:suite) do
    Book.all.each(&:destroy!)
    Book.create!(name: 'test')
  end

  config.before(:each) do
    Book.find_by(name: 'test').switch!
  end

  config.after(:each) do
    Apartment::Tenant.reset
  end
end