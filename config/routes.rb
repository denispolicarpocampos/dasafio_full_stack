# frozen_string_literal: true

Rails.application.routes.draw do
  namespace :api do
    namespace :v1 do
      post 'user_token' => 'user_token#create'
      resources :users, only: %i[index show create update destroy] do
        get 'current', on: :collection
      end
      resources :quizzes, only: %i[index show create update destroy]
    end
  end
end
