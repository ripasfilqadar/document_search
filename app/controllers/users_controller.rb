class UsersController < ApplicationController	
	
	def index
		a=b
		@user = User.all
	end

	def new
		authorize User
		binding.pry
		a=b
		@user = User.new
	end

	def create
		authorize User
		success, message, user = UserService.create(params[:user])
		binding.pry
		if success
			flash[:notice] = message
		else
			@user = user || User.new
			flash[:alert] = message
			render 'new'
		end
	end

	def update
		@user = User.find params[:id]
	end

	def destroy
		@user = User.find params[:id]
	end

	private

end