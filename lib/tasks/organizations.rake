logger = Mumukit::Nuntius::Logger

namespace :organizations do
  task listen: :environment do
    logger.info 'Listening to organizations'

    Mumukit::Nuntius::EventConsumer.start 'office'
  end
end
