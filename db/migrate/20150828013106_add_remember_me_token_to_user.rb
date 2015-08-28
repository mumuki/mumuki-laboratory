class AddRememberMeTokenToUser < ActiveRecord::Migration
  def change
    add_column :users, :remember_me_token, :string
  end
end
