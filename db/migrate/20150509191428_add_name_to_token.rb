class AddNameToToken < ActiveRecord::Migration
  def change
    add_column :api_tokens, :name, :string, null: false
  end
end
