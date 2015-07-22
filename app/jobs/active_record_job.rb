class ActiveRecordJob
  include SuckerPunch::Job

  def perform(args)
    Rails.logger.info("Running Job #{self.class.name} for with param #{args}")
    ActiveRecord::Base.connection_pool.with_connection do
      perform_with_connection(args)
    end
  end

  def self.run_async(args)
    new.async.perform(args)
  end
end
