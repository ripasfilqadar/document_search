module UserService
	module_function
	def login(*args) UserService::Login.new(*args).call; end
	def create(*args) UserService::Create.new(*args).call; end
end