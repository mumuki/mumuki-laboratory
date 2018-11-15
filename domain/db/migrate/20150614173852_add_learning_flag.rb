class AddLearningFlag < ActiveRecord::Migration[4.2]
  def change
    add_column :guides, :learning, :boolean, default: false
  end
end
