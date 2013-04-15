Projectx::Engine.routes.draw do

  get "type_definitions/index"

  get "type_definitions/new"

  get "type_definitions/create"

  get "type_definitions/edit"

  get "type_definitions/update"

  resources :misc_definitions
  resources :task_definitions
  resources :contracts, :only => [:index]
  resources :logs, :only => [:index]
  resources :projects do
    resources :contracts
    resources :task
    resources :logs
 
    collection do
      get :search
      put :search_results
      get :autocomplete
    end
  end
  resources :task_requests, :only => [:index]
  resources :tasks do
    resources :task_requests
    resources :logs
  end
  
  resources :task_requests do
    resources :logs
  end
  
  resources :project_types do
    resources :project_templates
  end
  resources :task_templates, :only => [:index]
  resources :project_templates do
    resources :task_templates
  end
end
