namespace :organizations do
  task :setup, [:name, :admin_email, :book_slug] => :environment do |t, args|
    organization = Organization.create! name: args[:name],
                                        contact_email: args[:admin_email],
                                        book: Book.find_by(slug: args[:book_slug])
    organization.switch!

    puts 'Congrats. A new organization has been created'
  end
end
