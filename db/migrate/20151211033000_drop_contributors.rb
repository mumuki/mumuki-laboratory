class DropContributors < ActiveRecord::Migration[4.2]
  def change
    drop_table :contributors
  end
end
