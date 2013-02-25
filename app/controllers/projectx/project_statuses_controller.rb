require_dependency "projectx/application_controller"

module Projectx
  class ProjectStatusesController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    
    helper_method 
    
    def index
      @title = 'Project Status Category'
      if has_create_right?('projectx_project_statuses') || has_update_right?('projectx_project_statuses')
        @project_statuses = Projectx::ProjectStatus.order("ranking_order")
      else
        @project_statuses = Projectx::ProjectStatus.where('active = ?', true).order("active DESC, ranking_order")
      end
    end

    def new
      @title = 'New Project Status Category'
      if has_create_right?('projectx_project_statuses')
        @project_status = Projectx::ProjectStatus.new()
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
    
    def create
      if has_create_right?('projectx_project_statuses')
        @project_status = Projectx::ProjectStatus.new(params[:project_status], :as => :role_new)
        @project_status.last_updated_by_id = session[:user_id]
        if @project_status.save
          redirect_to project_statuses_path, :notice => "Project Status Category Saved!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
    
    def edit
      @title = 'Edit Project Status Category'
      if has_update_right?('projectx_project_statuses')
        @project_status = Projectx::ProjectStatus.find(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")
      end
    end
  
    def update
      if has_update_right?('projectx_project_statuses')
        @project_status = Projectx::ProjectStatus.find(params[:id])
        @project_status.last_updated_by_id = session[:user_id]
        if @project_status.update_attributes(params[:project_status], :as => :role_update)
          redirect_to project_statuses_path, :notice => "Project Status Category Updated!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'edit'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end      
    end
  end
end
