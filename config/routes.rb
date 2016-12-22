Rails.application.routes.draw do
  mount RailsAdmin::Engine => '/admin', as: 'rails_admin'
  devise_for :users, :controllers => { :omniauth_callbacks => "callbacks" }

  root 'cards#index'
  get '/update', to: 'cards#update'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
