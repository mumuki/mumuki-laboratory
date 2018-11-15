class RemoveContactEmailFromBook < ActiveRecord::Migration[5.1]
  def change
    remove_column :books, :contact_email, :string
  end
end
