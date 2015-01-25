class AddTestSyntaxHintToLanguage < ActiveRecord::Migration
  def change
    add_column :languages, :test_syntax_hint, :text
  end
end
