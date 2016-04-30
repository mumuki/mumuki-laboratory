class AddChapterBook < ActiveRecord::Migration
  def change
    add_column :chapters, :book_id, :integer, index: true
  end
end
