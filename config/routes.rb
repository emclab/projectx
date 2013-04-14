Projectx::Engine.routes.draw do

  resources :misc_definitions
  resources :task_definitions
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

end
