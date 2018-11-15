class AddPrivateFlagForGuides < ActiveRecord::Migration[5.1]
  def change
    add_column :guides, :private, :boolean, default: false
  end
end
