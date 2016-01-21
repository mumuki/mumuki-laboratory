class AddTypeToEventSuscriber < ActiveRecord::Migration
  def change
    add_column :event_subscribers, :type, :string, default: 'EventSubscriber', null: false
  end
end
