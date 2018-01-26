class RemoveEventSubscriber < ActiveRecord::Migration[4.2]
  def change
    drop_table :event_subscribers
  end
end
