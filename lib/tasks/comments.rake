namespace :comments do
  task listen: :environment do

    Mumukit::Nuntius::Consumer.start "comments" do |delivery_info, properties, body|
      comment_data = Comment.parse_json JSON.parse(body).first

      Book.find_by(name: comment_data.delete('tenant')).switch!

      begin
        Comment.create! comment_data if comment_data["submission_id"].present?
      rescue ActiveRecord::RecordInvalid => e
        Rails.logger.info e
      end
    end
  end
end
