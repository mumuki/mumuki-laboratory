namespace :admin do
  task :create, [:book_name, :admin_email] => :environment do |t, args|
    book = Book.find_by name: args[:book_name]
    book.switch!

    password = Devise.friendly_token.first(10)
    AdminUser.create! email: args[:admin_email], password: password, password_confirmation: password

    puts "A new admin user has been created on book #{args[:book_name]}. Plase enter to admin panel with generated password #{password}"
  end
end
