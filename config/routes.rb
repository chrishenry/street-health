Rails.application.routes.draw do
  get 'addresses/index'

  root 'home#index'

  resources :addresses, only: [:index]


  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
end
