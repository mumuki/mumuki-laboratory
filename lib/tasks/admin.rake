namespace :admin do
  task :create, [:tenant_name, :admin_email] => :environment do |t, args|
    tenant = Tenant.find_by name: args[:tenant_name]
    tenant.switch!

    password = Devise.friendly_token.first(10)
    AdminUser.create! email: args[:admin_email], password: password, password_confirmation: password

    puts "A new admin user has been created on tenant #{args[:tenant_name]}. Plase enter to admin panel with generated password #{password}"
  end
end
