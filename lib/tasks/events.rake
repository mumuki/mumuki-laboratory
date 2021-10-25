logger = Mumukit::Nuntius::Logger

namespace :laboratory do
  namespace :events do
    task listen: :environment do
      logger.info 'Loading event handlers....'
      require_relative '../mumuki/laboratory/events/events'
      logger.info "Loaded handlers #{Mumukit::Nuntius::EventConsumer.handled_events}!"

      logger.info 'Listening to events...'
      Mumukit::Nuntius::EventConsumer.start!
    end
  end
end
