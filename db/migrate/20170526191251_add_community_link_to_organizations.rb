class AddCommunityLinkToOrganizations < ActiveRecord::Migration
  def change
    add_column :organizations, :community_link, :string
  end
end
