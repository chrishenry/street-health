Rails.application.routes.draw do
  get 'addresses/index'

  root 'home#index'

  resources :addresses
  get 'addresses/show/', to: 'addresses#show'
  get 'addresses/show/:address', to: 'addresses#show'

  resources :addresses do
    resources :servicerequests
  end

  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
end
