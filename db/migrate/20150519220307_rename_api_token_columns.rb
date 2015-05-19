class RenameApiTokenColumns < ActiveRecord::Migration
  def change
    rename_column :api_tokens, :name, :client_id
    rename_column :api_tokens, :value, :client_secret
  end
end
