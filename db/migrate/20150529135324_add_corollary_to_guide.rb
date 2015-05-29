class AddCorollaryToGuide < ActiveRecord::Migration
  def change
    add_column :guides, :corollary, :text
  end
end
