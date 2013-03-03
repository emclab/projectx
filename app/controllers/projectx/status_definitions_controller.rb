require_dependency "projectx/application_controller"

module Projectx
  class StatusDefinitionsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    before_filter :require_for_what
    
    def index
      @title = params[:for_what].capitalize + ' Status'
      #assume every employee has index right
      if has_create_right?('projectx_status_definitions') || has_update_right?('projectx_status_definitions')
        @status_definitions = Projectx::StatusDefinition.where(:for_what => params[:for_what]).order('active DESC, ranking_order')
      else
        @status_definitions = Projectx::StatusDefinition.where(:active => true).where(:for_what => params[:for_what]).order('ranking_order')
      end
    end
  
    def new
      @title = 'New ' + params[:for_what].capitalize + ' Status'
      if has_create_right?('projectx_status_definitions')
        @status_definition = Projectx::StatusDefinition.new
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def create
      if has_create_right?('projectx_status_definitions')
        @status_definition = Projectx::StatusDefinition.new(params[:status_definition], :as => :role_new)
        @status_definition.for_what = params[:for_what]
        @status_definition.last_updated_by_id = session[:user_id]
        if @status_definition.save
          redirect_to status_definitions_path, :notice => params[:for_what] + " Status Saved!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
  
    def edit
      @title = 'Update ' + params[:for_what].capitalize + ' Status'
      if has_update_right?("projectx_status_definitions")
        @status_definition = Projectx::StatusDefinition.find_by_id(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def update
      if  has_update_right?('projectx_status_definitions')
        @status_definition = Projectx::StatusDefinition.find_by_id(params[:id])
        @status_definition.last_updated_by_id = session[:user_id]
        if @status_definition.update_attributes(params[:status_definition], :as => :role_update)
          redirect_to status_definitions_path, :notice => params[:for_what].capitalize + "Status Updated!"
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
      return true if params[:for_what].present?
      flash.now[:error] = 'Missing Data (for_what)!'
      return false
    end
  end
end
