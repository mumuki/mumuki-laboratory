class RemoveTenantSubscriber < ActiveRecord::Migration[4.2]
  def change
    remove_column :event_subscribers, :type
  end
end
