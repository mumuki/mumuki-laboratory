class NonActiveUsersController < ApplicationController

	def send_email_non_active_users
		today_date = Time.now.strftime("%d/%m/%Y")
		users = User.where("today_date - created_at > 30")

		users.each do |user|
			if user.submissions_count == 0
				UserMail.motivation_email(user).deliver_later
			end
		end			
	end
	
end
