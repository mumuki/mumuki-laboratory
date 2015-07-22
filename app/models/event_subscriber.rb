class EventSubscriber < ActiveRecord::Base

  def notify_submission!(submission)
    response = JSON.parse(
        RestClient.post(
            "#{url}/events/submissions",
            submission.to_json,
            content_type: :json))

    if response != {status: 'ok'}
      Rails.logger.info "response from server #{response}"
    end
  end

  def self.notify_submission(submission)
    all.each do |it|
      it.notify_submission!(submission)
    end
  end
end
