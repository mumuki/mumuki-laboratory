ActiveAdmin.register ApiToken do

  permit_params :description

  filter :value
  filter :description

  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:value)
    column(:description)

    actions
  end
end
