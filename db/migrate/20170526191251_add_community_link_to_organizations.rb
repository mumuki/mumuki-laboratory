class AddCommunityLinkToOrganizations < ActiveRecord::Migration[4.2]
  def change
    add_column :organizations, :community_link, :string
  end
end
