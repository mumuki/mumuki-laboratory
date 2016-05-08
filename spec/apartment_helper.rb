RSpec.configure do |config|
  config.before(:suite) do
    Book.all.each(&:delete)
    Organization.all.each(&:delete)
    Organization.create!(name: 'test',
                         book: Book.new(name: 'test', slug: 'mumuki/mumuki-the-book'),
                         contact_email: 'foo@bar.com')
  end

  config.before(:each) do
    Organization.find_by(name: 'test').switch!
  end

  config.after(:each) do
    Apartment::Tenant.reset
  end

  config.after(:suite) do
    Organization.all.each(&:delete)
    Book.all.each(&:delete)
  end
end