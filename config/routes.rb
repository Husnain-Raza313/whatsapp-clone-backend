# frozen_string_literal: true

Rails.application.routes.draw do
  # For details on the DSL available within this file, see https://guides.rubyonrails.org/routing.html
  namespace :api, defaults: { format: :json } do
    namespace :v1 do
      post '/login', to: 'sessions#create'
      delete '/destroy', to: 'sessions#destroy'
      resources :users do
        member do
          get :verify_otp
        end
      end

      resources :chat_room_messages
      resources :chat_room_participants, only: [:show]
    end
  end
end
