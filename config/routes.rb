Rails.application.routes.draw do
  resource :session
  resources :passwords, param: :token
  resource :registration, only: [:new, :create]
  # Define your application routes per the DSL in https://guides.rubyonrails.org/routing.html

  # Reveal health status on /up that returns 200 if the app boots with no exceptions, otherwise 500.
  # Can be used by load balancers and uptime monitors to verify that the app is live.
  get "up" => "rails/health#show", :as => :rails_health_check

  # Render dynamic PWA files from app/views/pwa/* (remember to link manifest in application.html.erb)
  # get "manifest" => "rails/pwa#manifest", as: :pwa_manifest
  # get "service-worker" => "rails/pwa#service_worker", as: :pwa_service_worker

  # Defines the root path route ("/")
  root "home#home"

  namespace :admin do
    root "admin#index"
    resources :topics
    resources :blog
  end

  resources :quiz do
    get "/:id/finished", to: "quiz#finished", as: "finished"
    scope module: "quiz" do
      resources :question
    end
  end

  get "/quiz/:super_topic/:topic", to: "quiz#new", as: "new_quiz_seo"
  get "/quiz/:super_topic/:parent_topic/:sub_topic", to: "quiz#subtopic", as: "subtopic_quiz_seo"
end
