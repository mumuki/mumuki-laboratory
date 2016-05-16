class AddStatefulConsoleToLanguage < ActiveRecord::Migration
  def change
    add_column :languages, :stateful_console, :boolean, default: false
  end
end
