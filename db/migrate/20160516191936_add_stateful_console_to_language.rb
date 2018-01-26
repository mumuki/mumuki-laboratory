class AddStatefulConsoleToLanguage < ActiveRecord::Migration[4.2]
  def change
    add_column :languages, :stateful_console, :boolean, default: false
  end
end
