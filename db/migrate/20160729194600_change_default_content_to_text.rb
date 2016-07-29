class ChangeDefaultContentToText < ActiveRecord::Migration
  def change
    change_column :exercises, :default_content, :text
  end
end
