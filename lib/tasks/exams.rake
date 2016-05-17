namespace :exams do
  task listen: :environment do

    Mumukit::Nuntius::Consumer.start 'exams' do |_delivery_info, _properties, body|
      begin
        Exam.import_from_json!(body)
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.info e
      end
    end
  end
end
