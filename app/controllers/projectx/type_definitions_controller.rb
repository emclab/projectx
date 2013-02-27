require_dependency "projectx/application_controller"

module Projectx
  class TypeDefinitionsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    before_filter :require_for_what
    
    def index
      @title = params[:type_definition][:for_what].capitalize + ' Type'
      if has_create_right?('projectx_type_definitions') || has_update_right?('projectx_type_definitions')
        @type_definitions = Projectx::TypeDefinition.where(:for_what => params[:type_definition][:for_what]).order('active DESC, ranking_order')
      else
        @type_definitions = Projectx::TypeDefinition.where(:active => true).where(:for_what => params[:type_definition][:for_what]).order('ranking_order')
      end
    end
  
    def new
    end
  
    def create
    end
  
    def edit
    end
  
    def update
    end
    
    protected
    def require_for_what
      return true if params[:type_definition][:for_what].present?
    end
  end
end
