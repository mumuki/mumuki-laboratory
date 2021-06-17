logger = Mumukit::Nuntius::Logger

namespace :laboratory do
  namespace :messages do
    task listen: :environment do
      logger.info 'Listening to messages'

      Mumukit::Nuntius::Consumer.start 'teacher-messages', 'teacher-messages' do |_delivery_info, _properties, body|
        ApplicationRecord.with_pg_retry { Message.import_from_resource_h!(body) }
      rescue ActiveRecord::RecordInvalid => e
        logger.info e
      end
    end
  end
end
