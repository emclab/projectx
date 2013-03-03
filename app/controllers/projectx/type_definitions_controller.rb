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
      @title = 'New ' + params[:type_definition][:for_what].capitalize + ' Type'
      if has_create_right?('projectx_type_definitions')
        @type_definition = Projectx::TypeDefinition.new
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def create
      if has_create_right?('projectx_type_definitions')
        @type_definition = Projectx::TypeDefinition.new(params[:project_type], :as => :role_new)
        @type_definition.for_what = params[:type_definition][:for_what]
        @type_definition.last_updated_by_id = session[:user_id]
        if @type_definition.save
          redirect_to project_types_path, :notice => params[:type_definition][:for_what] + " Type Saved!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
  
    def edit
      @title = 'Update ' + params[:type_definition][:for_what].capitalize + ' Type'
      if has_update_right?("projectx_type_definitions")
        @type_definition = Projectx::TypeDefinition.find_by_id(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def update
      if  has_update_right?('projectx_type_definitions')
        @type_definition = Projectx::TypeDefinition.find_by_id(params[:id])
        @type_definition.last_updated_by_id = session[:user_id]
        if @type_definition.update_attributes(params[:type_definition], :as => :role_update)
          redirect_to type_definitions_path, :notice => params[:type_definition][:for_what].capitalize + "Type Updated!"
        else
          flash.now[:error] = 'Data Error. Not Updated!'
          render 'edit'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
    
    protected
    def require_for_what
      return true if params[:type_definition][:for_what].present?
      flash.now[:error] = 'Missing Data (for_what)!'
      return false
    end
  end
end
