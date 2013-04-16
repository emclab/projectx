# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class ProjectTemplatesController < ApplicationController
    before_filter :require_employee
    before_filter :load_project_type
    
    def index
      @title = '项目样板一览'
      if @type_definition
        @project_templates = @type_definition.project_templates.page(params[:page]).per_page(30) 
      else
        @project_templates = params[:projectx_project_templates][:model_ar_r].page(params[:page]).per_page(30) 
      end
    end
  
    def new
      @title = '新项目样板'
      @project_template = @type_definition.project_templates.new()
    end
  
    def create
      @project_template = @type_definition.project_templates.new(params[:project_template], :as => :role_new)
      @project_template.last_updated_by_id = session[:user_id]
      if @project_template.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=项目样板已保存!")
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = '更新项目样板'
      @project_template = Projectx::ProjectTemplate.find_by_id(params[:id])
    end
  
    def update
      @project_template = Projectx::ProjectTemplate.find_by_id(params[:id])
      @project_template.last_updated_by_id = session[:user_id]
      if @project_template.update_attributes(params[:project_template], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=项目样板已更新!")
      else
        flash.now[:error] = 'Data Error. Not Updated!'
        render 'edit'
      end
    end
  
    def show
      @title = '项目样板内容'
      @project_template = Projectx::ProjectTemplate.find_by_id(params[:id])
    end
    
    protected
    def load_project_type
      @type_definition = Projectx::TypeDefinition.find_by_id(params[:type_definition_id]) if params[:type_definition_id].present?
    end
  end
end
