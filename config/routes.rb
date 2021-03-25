Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html

  resources :users, only: :none do 
    resources :time_slots, :path => 'time-slots', only: %i(index create destroy)
  end
end
