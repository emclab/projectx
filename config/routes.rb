Projectx::Engine.routes.draw do

  resources :misc_definitions
  resources :task_definitions
  resources :task_for_project_types
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
  
  resources :tasks do
    resources :task_requests
    resources :logs
  end
  
  resources :task_requests do
    resources :logs
  end

end
