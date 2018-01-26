class ChangeGuideDescriptionToText < ActiveRecord::Migration[4.2]
  def change
    change_column :guides, :description, :text
  end
end
