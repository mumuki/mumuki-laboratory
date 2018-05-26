class AddTipsRulesToExercise < ActiveRecord::Migration[5.1]
  def change
    add_column :exercises, :tips_rules, :text
  end
end
