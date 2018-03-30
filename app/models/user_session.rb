class UserSession < Authlogic::Session::Base
	attr_reader :username, :password, :remember_me
  
end