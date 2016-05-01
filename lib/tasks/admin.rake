namespace :admin do
  task :create, [:organization_name, :admin_email] => :environment do |t, args|
    organization = Organization.find_by name: args[:organization_name]
    organization.switch!

    password = Devise.friendly_token.first(10)
    AdminUser.create! email: args[:admin_email], password: password, password_confirmation: password

    puts "A new admin user has been created on organization #{args[:organization_name]}. Plase enter to admin panel with generated password #{password}"
  end
end
