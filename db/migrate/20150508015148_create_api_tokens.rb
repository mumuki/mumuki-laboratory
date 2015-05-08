class CreateApiTokens < ActiveRecord::Migration
  def change
    create_table :api_tokens do |t|
      t.string :value
      t.string :description

      t.timestamps
    end
  end
end
