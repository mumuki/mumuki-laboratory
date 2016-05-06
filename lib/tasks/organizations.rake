namespace :organizations do
  task :setup, [:name, :admin_email, :locale, :book_slug] => :environment do |t, args|
    args.with_defaults(locale: 'es')

    organization = Organization.create! name: args[:name],
                                        contact_email: args[:admin_email],
                                        locale: args[:locale],
                                        book: Book.find_by(slug: args[:book_slug])
    organization.switch!

    puts 'Congrats. A new organization has been created'
  end
end
