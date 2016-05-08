class RemoveEventSubscriber < ActiveRecord::Migration
  def change
    drop_table :event_subscribers
  end
end
