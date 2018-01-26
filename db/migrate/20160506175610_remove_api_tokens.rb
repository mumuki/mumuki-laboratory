class RemoveApiTokens < ActiveRecord::Migration[4.2]
  def change
    drop_table :api_tokens
  end
end
