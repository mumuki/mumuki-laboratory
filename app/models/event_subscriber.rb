class EventSubscriber < ActiveRecord::Base

  def notify_submission!(submission)
    notify(submission.to_json, 'events/submissions')
  end

  def self.notify_submission(submission)
    all.where(enabled: true).each do |it|
      it.notify_submission!(submission)
    end
  end

  private

  def notify(event, path)
    response = JSON.parse(RestClient.post("#{url}/#{path}", event, content_type: :json))
    validate_response(response)
  end

  def validate_response(response)
    Rails.logger.info "response from server #{response}" if response != {'status' => 'ok'}
  end
end
