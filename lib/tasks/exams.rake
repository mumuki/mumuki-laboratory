logger = ::Logger.new(STDOUT)

namespace :laboratory do
  namespace :exams do
    task authorize_requests: :environment do
      logger.info "Exam Authorization Requests task"
      ExamRegistration.should_process.find_each do |exam_registration|
        logger.info "Processing exam registration '#{exam_registration.description}'"
        exam_registration.process_requests!
      rescue
        logger.error "Something wrong happened while processing '#{exam_registration.description}'"
      end
    end
  end
end
