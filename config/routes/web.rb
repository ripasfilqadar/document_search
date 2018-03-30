Rails.application.routes.draw do

  constraints subdomain: /^www$|^m$/ do
    get 'login' => 'user_session#new', as: 'login'
    post 'login' => 'user_session#create'
    get 'logout' => 'user_session#destroy', as: 'logout'

    get 'register' => 'user#new', as: 'register'
    post 'register' => 'user#create'
  end

end
