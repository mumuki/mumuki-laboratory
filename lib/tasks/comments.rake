logger = Mumukit::Nuntius::Logger

namespace :comments do
  task listen: :environment do
    logger.info 'Listening to comments'

    Mumukit::Nuntius::Consumer.start 'comments' do |_delivery_info, _properties, body|
      begin
        Comment.import_from_json!(body)
      rescue ActiveRecord::RecordInvalid => e
        logger.info e
      end
    end
  end
end
