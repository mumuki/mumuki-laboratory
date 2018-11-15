class ChangeDefaultContentToText < ActiveRecord::Migration[4.2]
  def change
    change_column :exercises, :default_content, :text
  end
end
