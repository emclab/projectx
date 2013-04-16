# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class TaskTemplatesController < ApplicationController
    before_filter :require_employee
    before_filter :load_project_template
    
    def index
      @title = '项目任务一览'
      if @project_template
        @task_templates = @project_template.task_templates.page(params[:page]).per_page(30) 
      else
        @task_templates = params[:projectx_task_templates][:model_ar_r].page(params[:page]).per_page(30) 
      end
    end
  
    def new
      @title = '新项目任务'
      @task_template = @project_template.task_templates.new()
    end
  
    def create
      @task_template = @project_template.task_templates.new(params[:task_template], :as => :role_new)
      @task_template.last_updated_by_id = session[:user_id]
      if @task_template.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=项目任务已保存!")
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = '更新项目任务'
      @task_template = Projectx::TaskTemplate.find_by_id(params[:id])
    end
  
    def update
      @task_template = Projectx::TaskTemplate.find_by_id(params[:id])
      @task_template.last_updated_by_id = session[:user_id]
      if @task_template.update_attributes(params[:task_template], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=项目任务已更新!")
      else
        flash.now[:error] = 'Data Error. Not Updated!'
        render 'edit'
      end
    end
  
    def show
      @title = '项目任务内容'
      @task_template = Projectx::TaskTemplate.find_by_id(params[:id])
    end
    
    protected
    def load_project_template
      @task_template = Projectx::TaskTemplate.find_by_id(params[:task_template_id]) if params[:task_template_id].present?
    end
  end
end
