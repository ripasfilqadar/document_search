module UserService
	class Create < Services::Base

		def initialize(params)
			@params = params
		end

		def perform
			begin
				message = nil
				success = false
				
				@user = User.new permit_attributes(@params)
				exist_user = (User.find_by_username (@user.username)) || (User.find_by_email (@user.email))
				if exist_user
					message = I18n.t('user.user_exist')
				else
					@user.save!
					success = true
				end
			rescue => e
				return [success, e.message, @user]
			end
			[success, message, @user]
		end
		private

		def permit_attributes(params)
			params.permit(:password, :email, :username, :name, :password_confirmation)
		end
	end	
end
