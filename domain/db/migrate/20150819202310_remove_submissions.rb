class RemoveSubmissions < ActiveRecord::Migration[4.2]
  def change
    drop_table :submissions
  end
end
