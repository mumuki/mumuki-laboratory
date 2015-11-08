class RemoveActAsTaggableTaggings < ActiveRecord::Migration
  def change
    drop_table :tags
    drop_table :taggings
  end
end
