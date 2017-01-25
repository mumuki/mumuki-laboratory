class InitializeNewFieldsOnOrganization < ActiveRecord::Migration
  def change
    change_table :organizations do |t|
      Organization.find_each do |orga|
        orga.public = !orga.public
        orga.book_ids = [orga.book_id]
        orga.save!
      end
    end
  end
end
