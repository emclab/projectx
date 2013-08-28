# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class ProjectTaskTemplatesController < ApplicationController
    before_filter :require_employee
    before_filter :load_project_type

    helper_method :return_task_definitions
    
    def index
      @title = 'Project Task Templates'
      if @type_definition
        @project_task_templates = @type_definition.project_task_templates.page(params[:page]).per_page(@max_pagination) 
      else
        @project_task_templates = params[:projectx_project_task_templates][:model_ar_r].page(params[:page]).per_page(@max_pagination) 
      end
    end
  
    def new
      @title = 'New Project Task Template'
      @project_task_template = @type_definition.project_task_templates.new()
      @project_task_template.task_templates.build()
    end
  
    def create
      @project_task_template = @type_definition.project_task_templates.new(params[:project_task_template], :as => :role_new)
      @project_task_template.last_updated_by_id = session[:user_id]
      if @project_task_template.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = 'Edit Project Task Template'
      @project_task_template = Projectx::ProjectTaskTemplate.find_by_id(params[:id])
    end
  
    def update
      @project_task_template = Projectx::ProjectTaskTemplate.find_by_id(params[:id])
      @project_task_template.last_updated_by_id = session[:user_id]
      if @project_task_template.update_attributes(params[:project_task_template], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash.now[:error] = 'Data Error. Not Updated!'
        render 'edit'
      end
    end
  
    def show
      @title = 'Project Task Template Info'
      @project_task_template = Projectx::ProjectTaskTemplate.find_by_id(params[:id])
    end
    
    protected
    def load_project_type
      @type_definition = Projectx::TypeDefinition.find_by_id(params[:type_definition_id]) if params[:type_definition_id].present?
    end
  end
end
