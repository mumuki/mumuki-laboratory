class ReplaceLearningWithTypeInGuides < ActiveRecord::Migration
  def change
    remove_column :guides, :learning, :boolean, default: false
    add_column :guides, :type, :integer, default: 0, null: false
  end
end
