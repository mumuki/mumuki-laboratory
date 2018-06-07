class AddTipsRulesToExercise < ActiveRecord::Migration[5.1]
  def change
    add_column :exercises, :assistance_rules, :text
  end
end
