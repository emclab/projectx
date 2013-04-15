# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class TaskRequestsController < ApplicationController
    before_filter :require_employee
    before_filter :load_task
    
    def index
      @title = '申请一览'
      if @task
        @task_requests = @task.task_requests.page(params[:page]).per_page(30) 
      else
        @task_requests = params[:projectx_task_requests][:model_ar_r].page(params[:page]).per_page(30) 
      end
    end
  
    def new
      @title = '输入新申请'
      @task_request = @task.task_requests.new
    end
  
    def create
      @task_request = @task.task_requests.new(params[:task_request], :as => :role_new)
      @task_reqeust.last_updated_by_id = session[:user_id]
      if @task_request.save
        redirect_to task_requests_path, :notice => '申请已保存!'
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = '更新申请'
      @task_request = Projectx::TaskRequest.find_by_id(params[:id])
    end
  
    def update
      @task_request = Projectx::TaskRequest.find_by_id(params[:id])
      @task_reqeust.last_updated_by_id = session[:user_id]
      if @task_request.update_attributes(params[:id], :as => :role_update)
        redirect_to project_task_path(@task.project, @task)
      else
        flash.now[:error] = 'Data Error. Not Updated!'
        render 'edit'
      end
    end
  
    def show
      @title = '申请内容'
      @task_request = Projectx::TaskRequest.find_by_id(params[:id])
    end
    
    protected
    def load_task
      @task = Projectx::Task.find_by_id(params[:task_id]) if params[:task_id].present? && params[:task_id].to_i > 0
    end
  end
end
