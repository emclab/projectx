# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class TasksController < ApplicationController
    before_filter :require_employee
    before_filter :load_project
    
    def index
      @title = 'Tasks'
      if @project
        @tasks = @project.tasks.page(params[:page]).per_page(@max_pagination) 
      else
        @tasks = params[:projectx_tasks][:model_ar_r].page(params[:page]).per_page(@max_pagination) 
      end
      @erb_code = find_config_const('task_index_view', 'projectx')
    end
  
    def new
      @title = 'New Task'
      @task = @project.tasks.new
    end
  
    def create
      @task = @project.tasks.new(params[:task], :as => :role_new)
      @task.last_updated_by_id = session[:user_id]
      if @task.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Saved!")
      else
        flash.now[:error] = t('Data Error. Not Saved!')
        render 'new'
      end
    end
  
    def edit
      @title = 'Edit Task'
      @task = Projectx::Task.find_by_id(params[:id])
    end
  
    def update
      @task = Projectx::Task.find_by_id(params[:id])
      @task.last_updated_by_id = session[:user_id]
      if @task.update_attributes(params[:task], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Successfully Updated!")
      else
        flash.now[:error] = t('Data Error. Not Updated!')
        render 'edit'
      end
    end
  
    def show
      @title = 'Task Info'
      @task = Projectx::Task.find_by_id(params[:id])
      @erb_code = find_config_const('task_show_view', 'projectx')
    end
    
    protected
    def load_project
      @project = Projectx::Project.find_by_id(params[:project_id]) if params[:project_id].present? && params[:project_id].to_i > 0
    end
  end
end
