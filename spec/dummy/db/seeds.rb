require 'mumuki/domain/seed'

Mumuki::Domain::Seed.import_languages!
Mumuki::Domain::Seed.import_main_contents!

Organization.find_or_create_by!(name: 'base') do |org|
  org.contact_email = 'issues@mumuki.org'
  org.book = Book.find_by!(slug: 'mumuki/mumuki-libro-programacion')
  org.public = true
  org.login_methods = Mumukit::Login::Settings.login_methods
  org.locale = 'es'
  org.time_zone = 'Buenos Aires'
end

Organization.find_or_create_by!(name: 'private') do |org|
  org.book = Book.find_by!(slug: 'mumuki/mumuki-libro-programacion')
  org.public = false
  org.time_zone = 'Buenos Aires'
end

Organization.find_or_create_by!(name: 'primaria') do |org|
  org.book = Book.find_by!(slug: 'mumukiproject/mumuki-libro-primaria')
  org.login_methods = Mumukit::Login::Settings.login_methods
  org.public = true
  org.time_zone = 'Buenos Aires'
end

Organization.find_or_create_by!(name: 'central') do |org|
  org.book = Book.find_by!(slug: 'mumuki/mumuki-libro-programacion')
  org.login_methods = Mumukit::Login::Settings.login_methods
  org.public = true
  org.time_zone = 'Buenos Aires'
end

User.find_or_create_by!(uid: 'dev.student@mumuki.org') { |org| org.permissions = {student: 'private/*'} }
User.find_or_create_by!(uid: 'dev.teacher@mumuki.org') { |org| org.permissions = {teacher: 'private/*'} }
User.find_or_create_by!(uid: 'dev.admin@mumuki.org') { |org| org.permissions = {admin: '*/*'} }
User.find_or_create_by!(uid: 'dev.owner@mumuki.org') { |org| org.permissions = {owner: '*/*'} }

Avatar.create!(image_url: 'user_shape.png')
