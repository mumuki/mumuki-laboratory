class RemoveLanguageHint < ActiveRecord::Migration
  def change
    remove_column :languages, :test_syntax_hint
  end
end
