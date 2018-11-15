class RemoveSlugFromLesson < ActiveRecord::Migration[4.2]
  def change
    remove_column :lessons, :slug
  end
end
