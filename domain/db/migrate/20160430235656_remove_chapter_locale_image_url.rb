class RemoveChapterLocaleImageUrl < ActiveRecord::Migration[4.2]
  def change
    remove_column :chapters, :locale
    remove_column :chapters, :image_url
  end
end
