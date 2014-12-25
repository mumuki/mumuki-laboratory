class ActiveRecordJob
  include SuckerPunch::Job

  def perform(id)
    Rails.logger.info("Running Job #{self.class.name} for id #{id}")
    ActiveRecord::Base.connection_pool.with_connection do
      perform_with_connection(id)
    end
  end

  def self.run_async(id)
    new.async.perform(id)
  end
end