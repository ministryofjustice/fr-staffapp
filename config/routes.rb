Rails.application.routes.draw do

  resource :notifications, only: [:edit, :update]

  post 'api/submissions' => 'api/submissions#create'
  post 'api/calculator/calculation' => 'api/calculator/calculations#create'
  get 'reports' => 'reports#index'
  get 'reports/public' => 'reports#public'
  get 'reports/finance_report' => 'reports#finance_report'
  get 'reports/graphs' => 'reports#graphs', as: :graphs_report
  put 'reports/finance_report' => 'reports#finance_report_generator'
  get 'letter_templates' => 'reports#letters'
  get 'reports/raw_data' => 'reports#raw_data'
  put 'reports/raw_data' => 'reports#raw_data_export'

  get '/applications/new' => 'applications/build#create'
  resources :applications, only: [] do

    collection do
      post 'create', to: 'applications/process#create', as: :create
    end

    get 'benefit_override/paper_evidence', to: 'benefit_overrides#paper_evidence'
    post 'benefit_override/paper_evidence_save', to: 'benefit_overrides#paper_evidence_save'

    get 'personal_information',
      to: 'applications/process#personal_information', as: :personal_information
    put 'personal_information',
      to: 'applications/process#personal_information_save', as: :personal_information_save
    get 'application_details',
      to: 'applications/process#application_details', as: :application_details
    put 'application_details',
      to: 'applications/process#application_details_save', as: :application_details_save
    get 'savings_investments',
      to: 'applications/process#savings_investments', as: :savings_investments
    put 'savings_investments',
      to: 'applications/process#savings_investments_save', as: :savings_investments_save
    get 'benefits', to: 'applications/process#benefits', as: :benefits
    put 'benefits', to: 'applications/process#benefits_save', as: :benefits_save
    get 'income', to: 'applications/process#income', as: :income
    put 'income', to: 'applications/process#income_save', as: :income_save
    get 'income_result', to: 'applications/process#income_result', as: :income_result
    get 'summary', to: 'applications/process#summary', as: :summary
    put 'summary_save', to: 'applications/process#summary_save', as: :summary_save
    get 'confirmation', to: 'applications/process#confirmation', as: :confirmation
    put 'override', to: 'applications/process#override', as: :override
  end

  resources :online_applications, only: [:edit, :update, :show] do
    member do
      post :complete
    end
  end

  resources :evidence, only: :show do
    member do
      get :accuracy
      post :accuracy_save
      get :income
      post :income_save
      get :result
      get :summary
      post :summary_save
      get :confirmation
      get :return_letter
      post :return_application
    end
  end

  resources :evidence_checks, only: :show

  resources :part_payments, only: :show do
    member do
      get :accuracy
      post :accuracy_save
      get :summary
      post :summary_save
      get :confirmation
      get :return_letter
      post :return_application
    end
  end

  resources :processed_applications, only: [:index, :show, :update]
  resources :deleted_applications, only: [:index, :show]

  get 'guide' => 'guide#index'
  get 'guide/process_application' => 'guide#process_application'
  get 'guide/evidence_checks' => 'guide#evidence_checks'
  get 'guide/part_payments' => 'guide#part_payments'
  get 'guide/appeals' => 'guide#appeals'
  get 'guide/suspected_fraud' => 'guide#suspected_fraud'

  get 'ping' => 'health_status#ping'
  get 'healthcheck' => 'health_status#healthcheck'
  get 'raise_exception' => 'health_status#raise_exception'

  get 'feedback' => 'feedback#new'
  get 'feedback/display' => 'feedback#index'

  post 'feedback/create' => 'feedback#create'

  resources :offices do
    resources :business_entities do
      member do
        get 'deactivate'
        post 'confirm_deactivate'
      end
    end
  end

  root to: 'home#index'

  get 'home/index'
  post 'home/online_search'
  post 'home/completed_search'

  ['400', '404', '500', '503'].each do |error|
    get "static/#{error}" => "static##{error}"
  end

  get 'users/deleted' => 'users#deleted', as: 'deleted_users'
  patch 'users/:id/restore' => 'users#restore', as: 'restore_user'
  devise_for :users, skip: :registrations, controllers: {
    invitations: 'users/invitations',
    passwords: 'users/passwords',
    sessions: 'users/sessions',
    confirmations: 'users/confirmations'
  }
  resources :users
  as :user do
    get 'users/:id/change_password' => 'users/registrations#edit', as: 'edit_user_registration'
    patch 'users/:id/change_password' => 'users/registrations#update', as: 'user_registration'
  end
end
