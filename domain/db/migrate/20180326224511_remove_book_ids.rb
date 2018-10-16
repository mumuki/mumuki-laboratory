class RemoveBookIds < ActiveRecord::Migration[5.1]
  def change
    remove_column :organizations, :book_ids
  end
end
