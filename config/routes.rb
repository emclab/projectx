Projectx::Engine.routes.draw do
 
  get "type_definitions/index"

  get "type_definitions/new"

  get "type_definitions/create"

  get "type_definitions/edit"

  get "type_definitions/update"

  resources :project_types
  resources :project_statuses

end
