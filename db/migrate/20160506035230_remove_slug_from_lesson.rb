class RemoveSlugFromLesson < ActiveRecord::Migration
  def change
    remove_column :lessons, :slug
  end
end
