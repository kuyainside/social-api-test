Rails.application.routes.draw do
  apipie
  # For details on the DSL available within this file, see http://guides.rubyonrails.org/routing.html
  namespace :api do
    resources :friends, only: [:index, :create] do
      collection do
        post :common
      end
    end

    resources :subscribes, only: [:create] do
      collection do
        post :block
        post :send_email
        post :unblock
      end
    end
  end
end
