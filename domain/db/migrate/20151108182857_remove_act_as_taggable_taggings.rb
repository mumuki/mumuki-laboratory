class RemoveActAsTaggableTaggings < ActiveRecord::Migration[4.2]
  def change
    drop_table :tags
    drop_table :taggings
  end
end
