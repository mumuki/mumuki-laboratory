class RemoveSlugs < ActiveRecord::Migration[4.2]
  def change
    drop_table :friendly_id_slugs
  end
end
