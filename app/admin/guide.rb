ActiveAdmin.register Guide do

  permit_params :name, :description, :github_repository, :position, :path_id

  filter :name
  filter :description
  filter :path
  filter :created_at
  filter :updated_at

  index do
    column(:id)
    column(:name)
    column(:path)
    column(:position)
    column(:description)
    column(:github_repository)

    actions
  end
end
