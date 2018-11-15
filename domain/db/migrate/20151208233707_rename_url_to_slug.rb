class RenameUrlToSlug < ActiveRecord::Migration[4.2]
  def change
   rename_column :guides, :url, :slug
  end
end
