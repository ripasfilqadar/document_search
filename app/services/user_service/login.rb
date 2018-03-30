module UserService
	class Login < Services::Base

		def initialize(user_session)
			@session_params = user_session
		end

		def perform
			logged_in = false
			user_session = nil
			message = nil
			begin
				binding.pry
				user_session = UserSession.new(permitted_params)			
				logged_in = true if user_session.save
			rescue => e
				message = e.message
			end

			[logged_in, user_session, message]
		end

		private
		def permitted_params
			@session_params.require(:user_session).permit(:username, :password)
		end
	end
end