Rails.application.routes.draw do
  root 'home#index'

  get 'help' => 'static_pages#help'
  get 'about' => 'static_pages#about'
end
