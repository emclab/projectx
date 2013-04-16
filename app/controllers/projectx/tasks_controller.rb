# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class TasksController < ApplicationController
    before_filter :require_employee
    before_filter :load_project
    
    def index
      @title = '项目任务一览'
      if @project
        @tasks = @project.tasks.page(params[:page]).per_page(30) 
      else
        @tasks = params[:projectx_tasks][:model_ar_r].page(params[:page]).per_page(30) 
      end
    end
  
    def new
      @title = '新项目任务'
      @task = @project.tasks.new
    end
  
    def create
      @task = @project.tasks.new(params[:task], :as => :role_new)
      @task.last_updated_by_id = session[:user_id]
      if @task.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=任务已保存!")
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = '更新任务'
      @task = Projectx::Task.find_by_id(params[:id])
    end
  
    def update
      @task = Projectx::Task.find_by_id(params[:id])
      @task.last_updated_by_id = session[:user_id]
      if @task.update_attributes(params[:id], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=任务已更新!")
      else
        flash.now[:error] = 'Data Error. Not Updated!'
        render 'edit'
      end
    end
  
    def show
      @title = '项目任务内容'
      @task = Projectx::Task.find_by_id(params[:id])
    end
    
    protected
    def load_project
      @project = Projectx::Project.find_by_id(params[:project_id]) if params[:project_id].present? && params[:project_id].to_i > 0
    end
  end
end
