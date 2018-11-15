class AddReadedToComment < ActiveRecord::Migration[4.2]
  def change
    add_column :comments, :readed, :boolean, default: false
  end
end
