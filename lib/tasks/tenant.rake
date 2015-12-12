namespace :tenant do
  task :setup, [:name, :admin_email] => :environment do |t, args|
    tenant = Tenant.create! name: args[:name], contact_email: args[:admin_email]
    tenant.switch!

    password = Devise.friendly_token.first(10)
    AdminUser.create! email: args[:admin_email], password: password, password_confirmation: password

    puts "Congrats. A new tenant has been created. Plase enter to admin panel with generated password #{password}"
  end
end
