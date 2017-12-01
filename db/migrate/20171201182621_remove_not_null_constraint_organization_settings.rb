class RemoveNotNullConstraintOrganizationSettings < ActiveRecord::Migration[5.1]
  def change
    change_column :organizations, :settings, :text, null: true
    change_column :organizations, :theme, :text, null: true
    change_column :organizations, :profile, :text, null: true
  end
end


