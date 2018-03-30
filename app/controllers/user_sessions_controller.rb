class UserSessionsController < ApplicationController
	def index
		authorize UserSession
	end

	def new
		authorize UserSession
		@user_session = UserSession.new
	end

	def create
		authorize UserSession
		logged_in, @user_session, login_message = UserService.login(params)
		binding.pry
		if logged_in
			puts current_user
		else
			@user_session ||= UserSession.new
			render 'new'
		end
	end

	def destroy
		authorize UserSession
	end
end