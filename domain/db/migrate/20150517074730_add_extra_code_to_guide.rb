class AddExtraCodeToGuide < ActiveRecord::Migration[4.2]
  def change
    add_column :guides, :extra_code, :text
  end
end
