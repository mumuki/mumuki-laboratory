class AddImageUrlToUser < ActiveRecord::Migration[4.2]
  def change
    add_column :users, :image_url, :string
  end
end
