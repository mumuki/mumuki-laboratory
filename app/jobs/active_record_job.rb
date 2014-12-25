class ActiveRecordJob
  include SuckerPunch::Job

  def perform(id)
    ActiveRecord::Base.connection_pool.with_connection do
      perform_with_connection(id)
    end
  end
end