RSpec.configure do |config|
  config.before(:suite) do
    Organization.all.each(&:destroy!)
    Organization.create!(name: 'test', book: Book.new(name: 'test'), contact_email: 'foo@bar.com')
  end

  config.before(:each) do
    Organization.find_by(name: 'test').switch!
  end

  config.after(:each) do
    Apartment::Tenant.reset
  end
end