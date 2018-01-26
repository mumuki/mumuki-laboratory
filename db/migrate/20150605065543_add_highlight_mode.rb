class AddHighlightMode < ActiveRecord::Migration[4.2]
  def change
    add_column :languages, :highlight_mode, :string, null: true
  end
end
