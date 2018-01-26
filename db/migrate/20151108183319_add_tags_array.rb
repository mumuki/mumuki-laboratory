class AddTagsArray < ActiveRecord::Migration[4.2]
  def change
    add_column :exercises, :tag_list, :text, array:true, default: []
  end
end
