class AddPromptToLanguage < ActiveRecord::Migration
  def change
    add_column :languages, :prompt, :string
  end
end
