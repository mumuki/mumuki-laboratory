namespace :comments do
  task listen: :environment do

    Mumukit::Nuntius::Consumer.start 'comments' do |_delivery_info, _properties, body|
      begin
        Comment.import_from_json!(body)
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.info e
      end
    end
  end
end
