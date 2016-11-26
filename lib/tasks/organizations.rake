namespace :organizations do
  task :setup, [:name, :contact_email, :book_slug, :logo_url] => :environment do |t, args|
    args.with_defaults(logo_url: "#{Rails.configuration.base_url}/logo-alt-large.png")

    organization = Organization.create! name: args[:name],
                                        contact_email: args[:contact_email],
                                        book: Book.find_by(slug: args[:book_slug]),
                                        logo_url: args[:logo_url],
                                        private: true
    organization.switch!

    puts 'Congrats. A new organization has been created'
  end
end
