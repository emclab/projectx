Projectx::Engine.routes.draw do

  resources :misc_definitions
  resources :task_definitions
  resources :payments, :only => [:index]
  resources :payments do
    collection do
      get :search
      put :search_results
      get :autocomplete
    end
  end
  resources :contracts, :only => [:index]
  resources :contracts do
    collection do
      get :search
      put :search_results
      get :autocomplete
    end
  end
  resources :logs, :only => [:index]
  resources :projects do
    resources :contracts
    resources :tasks
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
  
  resources :project_task_templates, :only => [:index]
  resources :type_definitions do
    resources :project_task_templates
  end
  resources :task_templates, :only => [:index]
  resources :project_task_templates do
    resources :task_templates
  end
end
