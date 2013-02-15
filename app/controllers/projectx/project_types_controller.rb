require_dependency "projectx/application_controller"

module Projectx
  class ProjectTypesController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    
    def index
      @title = 'Project Type'
      if has_create_right?('projectx_project_types') || has_update_right?('projectx_project_types')
        @project_types = Projectx::ProjectType.order('active DESC, name')
      else
        @project_types = Projectx::ProjectType.where(:active => true).order('name')
      end
    end
  
    def new
      @title = 'New Project Type'
      if has_create_right?('projectx_project_types')
        @project_type = Projectx::ProjectType.new
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def create
      if has_create_right?('projectx_project_types')
        @project_type = Projectx::ProjectType.new(params[:project_type], :as => :role_new)
        @project_type.last_updated_by_id = session[:user_id]
        if @project_type.save
          redirect_to project_types_path, :notice => "Project Type Saved!"
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      end
    end
  
    def edit
      @title = 'Update Project Type'
      if has_update_right?("projectx_project_types")
        @project_type = Projectx::ProjectType.find_by_id(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def update
      if  has_update_right?('projectx_project_types')
        @project_type = Projectx::ProjectType.find_by_id(params[:id])
        @project_type.last_updated_by_id = session[:user_id]
        if @project_type.update_attributes(params[:project_type], :as => :role_update)
          redirect_to project_types_path, :notice => "Project Type Updated!"
        else
          flash.now[:error] = 'Data Error. Not Updated!'
          render 'edit'
        end
      end
    end
  end
end
