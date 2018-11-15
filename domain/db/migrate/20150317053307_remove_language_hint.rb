class RemoveLanguageHint < ActiveRecord::Migration[4.2]
  def change
    remove_column :languages, :test_syntax_hint
  end
end
