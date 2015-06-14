class AddLearningFlag < ActiveRecord::Migration
  def change
    add_column :guides, :learning, :boolean
  end
end
