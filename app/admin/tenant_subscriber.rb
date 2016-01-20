ActiveAdmin.register TenantSubscriber do

  permit_params :enabled, :url

  filter :url
  filter :enabled

  index do
    column :url
    column :enabled

    actions
  end
end
