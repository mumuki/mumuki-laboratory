class AddChapterBook < ActiveRecord::Migration[4.2]
  def change
    add_column :chapters, :book_id, :integer, index: true
  end
end
