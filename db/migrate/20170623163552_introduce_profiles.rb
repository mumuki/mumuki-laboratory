class IntroduceProfiles < ActiveRecord::Migration
  def change
    add_column :users, :profile,   :text, default: "{}", null: false

    remove_column :users, :social_id
    remove_column :users, :image_url
    remove_column :users, :email
    remove_column :users, :first_name
    remove_column :users, :last_name
    remove_column :users, :name
  end
end
