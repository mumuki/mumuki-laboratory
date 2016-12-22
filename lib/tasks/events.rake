logger = Mumukit::Nuntius::Logger

namespace :events do
  task listen: :environment do
    logger.info 'Listening to events'
    Mumukit::Nuntius::EventConsumer.start 'atheneum'
  end
end
