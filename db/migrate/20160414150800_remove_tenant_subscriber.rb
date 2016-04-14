class RemoveTenantSubscriber < ActiveRecord::Migration
  def change
    remove_column :event_subscribers, :type
  end
end
