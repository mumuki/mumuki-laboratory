class CreateOrganizationObjects < ActiveRecord::Migration
  def change
    Book.all.each do |it|
      Organization.create! name: it.name, contact_email: it.contact_email, description: it.preface, book: it
    end
  end
end
