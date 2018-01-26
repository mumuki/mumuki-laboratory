class AddTypeToEventSuscriber < ActiveRecord::Migration[4.2]
  def change
    add_column :event_subscribers, :type, :string, default: 'EventSubscriber', null: false
  end
end
