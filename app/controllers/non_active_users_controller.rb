class NonActiveUsersController < ApplicationController

	def self.send_email_non_active_users
		users = User.where(" created_at < :date ", date: 30.days.ago).reject { |user| !user.has_submissions? }
		users.each do |user|
				UserMailer.motivation_email(user).deliver
    end
	end
	
end
