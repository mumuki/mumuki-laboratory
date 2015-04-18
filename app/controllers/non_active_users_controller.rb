class NonActiveUsersController < ApplicationController

	def self.send_email_non_active_users
		users = User.where(" created_at < :date ", date: 30.days.ago)
		users.each do |user|
			if user.has_submissions?
				UserMailer.motivation_email(user).deliver
			end
		end	
	end
	
end
