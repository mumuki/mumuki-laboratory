logger = Mumukit::Nuntius::Logger

namespace :laboratory do
  namespace :jobs do
    task listen: :environment do
      logger.info 'Loading job handlers....'
      require_relative '../mumuki/laboratory/jobs/jobs'
      logger.info "Loaded handlers #{Mumukit::Nuntius::JobConsumer.handled_jobs}!"

      logger.info 'Listening to jobs...'
      Mumukit::Nuntius::JobConsumer.start!
    end
  end
end
