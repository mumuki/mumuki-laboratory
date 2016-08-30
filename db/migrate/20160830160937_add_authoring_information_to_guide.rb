class AddAuthoringInformationToGuide < ActiveRecord::Migration
  def change
    add_column :guides, :authors, :text
    add_column :guides, :contributors, :text
  end
end
