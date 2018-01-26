class AddBetaFlag < ActiveRecord::Migration[4.2]
  def change
    add_column :guides, :beta, :boolean, default: false
  end
end
