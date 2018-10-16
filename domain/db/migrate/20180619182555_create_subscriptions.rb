class CreateSubscriptions < ActiveRecord::Migration[5.1]
  def change
    create_table :subscriptions do |t|
      t.references :user, index: true
      t.references :discussion, index: true
      t.boolean :read, default: true
    end
  end
end
