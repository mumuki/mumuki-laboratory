logger = Mumukit::Nuntius::Logger

namespace :commands do
  task listen: :environment do
    logger.info 'Listening to commands'

    Mumukit::Nuntius::Consumer.start 'atheneum-commands' do |_delivery_info, _properties, body|
      begin
        command = choose_command(body)
        command.execute!(body)
      rescue ActiveRecord::RecordInvalid => e
        logger.info e
      end
    end
  end
end

def choose_command(body)
  "Command::#{body.delete('type')}".constanize
end
