ActiveAdmin.register ApiToken do

  permit_params :name, :value, :description

  filter :name
  filter :value
  filter :description
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:name)
    column(:value)
    column(:description)

    actions
  end
end
