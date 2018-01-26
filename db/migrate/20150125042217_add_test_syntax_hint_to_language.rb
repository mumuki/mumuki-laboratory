class AddTestSyntaxHintToLanguage < ActiveRecord::Migration[4.2]
  def change
    add_column :languages, :test_syntax_hint, :text
  end
end
