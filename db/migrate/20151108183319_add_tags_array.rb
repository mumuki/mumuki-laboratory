class AddTagsArray < ActiveRecord::Migration
  def change
    add_column :exercises, :tag_list, :text, array:true, default: []
  end
end
