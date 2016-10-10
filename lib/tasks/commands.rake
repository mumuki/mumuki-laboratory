logger = Mumukit::Nuntius::Logger

namespace :commands do
  task listen: :environment do
    logger.info 'Listening to commands'
    Mumukit::Nuntius::CommandConsumer.start 'atheneum'
  end
end
