ActiveAdmin.register Language do

  permit_params :name, :image_url,
                :extension, :test_runner_url,
                :visible_success_output, :output_content_type

  filter :name
  filter :created_at
  filter :updated_at
  filter :output_content_type

  index do
    column(:id)
    column(:name)
    column(:image_url)
    column(:extension)
    column(:test_runner_url)
    column(:visible_success_output)
    column(:output_content_type)

    actions
  end
end
