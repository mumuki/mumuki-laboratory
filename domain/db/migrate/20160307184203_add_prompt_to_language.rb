class AddPromptToLanguage < ActiveRecord::Migration[4.2]
  def change
    add_column :languages, :prompt, :string
  end
end
