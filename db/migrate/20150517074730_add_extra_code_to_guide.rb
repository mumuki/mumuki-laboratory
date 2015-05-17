class AddExtraCodeToGuide < ActiveRecord::Migration
  def change
    add_column :guides, :extra_code, :text
  end
end
