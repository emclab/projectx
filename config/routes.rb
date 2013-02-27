Projectx::Engine.routes.draw do
 
  resources :type_definitions
  resources :status_definitions  
  resources :task_for_project_types
  resources :contracts, :only => [:index]
  resources :projects do
    resources :skip_task_for_projects
    resources :contracts
    resources :task_executions
  end
  

end
