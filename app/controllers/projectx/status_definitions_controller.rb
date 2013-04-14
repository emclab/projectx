require_dependency "projectx/application_controller"

module Projectx
  class StatusDefinitionsController < ApplicationController
    prepend_before_filter :require_signin, :require_employee, :require_for_what

    def index
      @title = params[:for_what].capitalize + ' Status'
      @status_definitions = Projectx::StatusDefinition.where(:for_what => params[:for_what]).order('active DESC, ranking_order')
    end
  
    def new
      @title = 'New ' + params[:for_what].capitalize + ' Status'
      @status_definition = Projectx::StatusDefinition.new
    end
  
    def create
      @status_definition = Projectx::StatusDefinition.new(params[:status_definition], :as => :role_new)
      @status_definition.for_what = params[:for_what]
      @status_definition.last_updated_by_id = session[:user_id]
      if @status_definition.save
        redirect_to status_definitions_path, :notice => params[:for_what] + " Status Saved!"
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = 'Update ' + params[:for_what].capitalize + ' Status'
      @status_definition = Projectx::StatusDefinition.find_by_id(params[:id])
    end
  
    def update
      @status_definition = Projectx::StatusDefinition.find_by_id(params[:id])
      @status_definition.last_updated_by_id = session[:user_id]
      if @status_definition.update_attributes(params[:status_definition], :as => :role_update)
        redirect_to status_definitions_path, :notice => params[:for_what].capitalize + "Status Updated!"
      else
        flash.now[:error] = 'Data Error. Not Updated!'
        render 'edit'
      end
    end
    
    protected
    def require_for_what
      unless params[:for_what].present?
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Missing Data!") 
      end
    end
  end
end
