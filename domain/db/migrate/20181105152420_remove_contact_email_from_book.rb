class RemoveContactEmailFromBook < ActiveRecord::Migration[5.1]
  def change
    remove_column :books, :contact_email
  end
end
