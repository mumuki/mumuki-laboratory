class NonActiveUsersController < ApplicationController

	def send_email_non_active_users
		users = User.where(" created_at < :date ", date: 30.days.ago)
		users.each do |user|
			if user.has_submissions?
				UserMail.motivation_email(user).deliver_later
			end
		end			
	end
	
end
