class AddLearningFlag < ActiveRecord::Migration
  def change
    add_column :guides, :learning, :boolean, default: false
  end
end
