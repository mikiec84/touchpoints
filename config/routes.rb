Rails.application.routes.draw do
  devise_for :users

  resources :touchpoints, only: [:index, :show] do
    member do
      get "submit", to: "submissions#new", touchpoint: true, as: :submit
      get "js", to: "touchpoints#js", as: :js
    end
    resources :forms
    resources :submissions, only: [:new, :create, :show] do
    end
  end

  namespace :admin do
    resources :containers
    resources :forms
    resources :users, except: [:new]
    resources :organizations
    resources :programs
    resources :services do
      member do
        post "add_user", to: "services#add_user", as: :add_user
        post "remove_user", to: "services#remove_user", as: :remove_user
      end
    end
    resources :submissions, except: [:new, :index, :create]
    resources :triggers
    resources :touchpoints do
      member do
        get "export_submissions", to: "touchpoints#export_submissions", as: :export_submissions
        get "example", to: "touchpoints#example", as: :example
        get "example/gtm", to: "touchpoints#gtm_example", as: :gtm_example
      end
      resources :forms
      resources :submissions, only: [:new, :show, :create]
    end
    root to: "site#index"
  end

  get "status", to: "site#status", as: :status
  get "onboarding", to: "site#onboarding", as: :onboarding
  root to: "site#index"
end
