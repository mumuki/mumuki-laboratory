ActiveAdmin.register Guide do

  permit_params :name, :description, :github_repository

  filter :name
  filter :description
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:name)
    column(:description)
    column(:github_repository)

    actions
  end
end
