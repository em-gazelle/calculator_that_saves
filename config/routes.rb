Rails.application.routes.draw do
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html

  root 'calculators#index', as: 'calculator'
  resources :calculators, only: [:create, :index]

  namespace :api do  
  	resources :calculators, only: [:create, :index]
  end

end
