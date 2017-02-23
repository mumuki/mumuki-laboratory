module Mumukit::Nuntius::EventConsumer
  def self.handled_events
    @@handlers.keys
  end
end

logger = Mumukit::Nuntius::Logger
namespace :events do
  task listen: :environment do
    logger.info 'Loading event handlers....'
    require_relative '../events'
    logger.info "Loaded handlers #{Mumukit::Nuntius::EventConsumer.handled_events}!"

    logger.info 'Listening to events...'
    Mumukit::Nuntius::EventConsumer.start!
  end
end
