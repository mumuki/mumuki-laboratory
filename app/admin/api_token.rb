ActiveAdmin.register ApiToken do

  permit_params :client_id, :client_secret, :description

  filter :client_id
  filter :description
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:client_id)
    column(:client_secret)
    column(:description)

    actions
  end
end
