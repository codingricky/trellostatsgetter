Rails.application.routes.draw do
  
  resources :cards

  root 'cards#index'

  get 'update', to: 'cards#update'
  get 'delete', to: 'cards#delete'
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
end
