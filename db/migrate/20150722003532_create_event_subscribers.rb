class CreateEventSubscribers < ActiveRecord::Migration
  def change
    create_table :event_subscribers do |t|
      t.string :url
      t.boolean :enabled

      t.timestamps
    end
  end
end
