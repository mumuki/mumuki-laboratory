class AddApiClient < ActiveRecord::Migration[5.1]
  def change
    create_table :api_clients do |t|
      t.string :description
      t.string :token
      t.references :user

      t.timestamps
    end
  end
end
