Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  constraints subdomain: /^www$|^m$/ do
    get 'login' => 'user_sessions#new', as: 'login'
    get 'logout' => 'user_sessions#destroy', as: 'logout'

    get 'register' => 'users#new', as: 'register'
    resources :user_sessions, only: [:create]

    resources :users, except: [:new]
  end

end
