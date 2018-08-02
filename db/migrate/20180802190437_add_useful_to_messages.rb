class AddUsefulToMessages < ActiveRecord::Migration[5.1]
  def change
    add_column :messages, :useful, :boolean, default: false
  end
end
