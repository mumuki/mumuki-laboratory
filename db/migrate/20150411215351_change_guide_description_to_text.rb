class ChangeGuideDescriptionToText < ActiveRecord::Migration
  def change
    change_column :guides, :description, :text
  end
end
