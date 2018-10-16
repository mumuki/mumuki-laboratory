class RemoveAuthors < ActiveRecord::Migration[4.2]
  def change
    remove_column :exercises, :author_id
    remove_column :guides, :author_id
  end
end
