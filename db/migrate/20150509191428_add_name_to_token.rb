class AddNameToToken < ActiveRecord::Migration[4.2]
  def change
    add_column :api_tokens, :name, :string, null: false
  end
end
