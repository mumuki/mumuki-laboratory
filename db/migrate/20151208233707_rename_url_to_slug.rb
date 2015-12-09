class RenameUrlToSlug < ActiveRecord::Migration
  def change
   rename_column :guides, :url, :slug
  end
end
