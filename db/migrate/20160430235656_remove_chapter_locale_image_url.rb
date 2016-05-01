class RemoveChapterLocaleImageUrl < ActiveRecord::Migration
  def change
    remove_column :chapters, :locale
    remove_column :chapters, :image_url
  end
end
