class AddCorollaryToGuide < ActiveRecord::Migration[4.2]
  def change
    add_column :guides, :corollary, :text
  end
end
