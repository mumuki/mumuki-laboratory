class AddApprovedToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :approved, :boolean, default: false
  end
end
