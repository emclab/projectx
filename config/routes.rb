Projectx::Engine.routes.draw do
 
  get "status_definitions/index"

  get "status_definitions/new"

  get "status_definitions/create"

  get "status_definitions/edit"

  get "status_definitions/update"

  resources :type_definitions
  resources :task_definitions
  resources :status_definitions
  resources :task_for_project_types
  resources :contracts, :only => [:index]
  resources :projects do
    resources :skip_task_for_projects
    resources :contracts
    resources :task_executions
    resources :sales
    resources :customer
    resources :project_manager
    collection do
      get :search
      put :search_results
      get :autocomplete
    end
  end
  
  resources :customers do
    resources :sales_leads
    resources :customer_comm_records
    collection do
      get :search
      put :search_results
      get :stats
      put :stats_results 
      get :autocomplete
    end
  end
  

end
