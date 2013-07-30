# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class TaskRequestsController < ApplicationController
    before_filter :require_employee
    before_filter :load_task
    
    def index
      @title = 'Task Requests'
      if @task
        @task_requests = @task.task_requests.page(params[:page]).per_page(@max_pagination) 
      else
        @task_requests = params[:projectx_task_requests][:model_ar_r].page(params[:page]).per_page(@max_pagination) 
      end
    end
  
    def new
      @title = 'New Task Request'
      @task_request = @task.task_requests.new
    end
  
    def create
      remove_fields_if_not_need_delivery() if params[:task_request][:need_delivery] == '0' #remove 2 related fields before @task.task_request.new
      @task_request = @task.task_requests.new(params[:task_request], :as => :role_new)
      @task_request.requested_by_id = session[:user_id]
      @task_request.last_updated_by_id = session[:user_id]  #clean up fields
      if @task_request.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=申请已保存!") 
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = 'Edit Task Request'
      @task_request = Projectx::TaskRequest.find_by_id(params[:id])
    end
  
    def update
      remove_fields_if_not_need_delivery() if params[:task_request][:need_delivery] == '0' #remove 2 related fields before @task_request.update_attributes
      @task_request = Projectx::TaskRequest.find_by_id(params[:id])
      @task_request.last_updated_by_id = session[:user_id]
      if @task_request.update_attributes(params[:task_request], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=申请已更新!") 
      else
        flash.now[:error] = 'Data Error. Not Updated!'
        render 'edit'
      end
    end
  
    def show
      @title = 'Task Request Info'
      @task_request = Projectx::TaskRequest.find_by_id(params[:id])
    end
    
    protected
    def load_task
      @task = Projectx::Task.find_by_id(params[:task_id]) if params[:task_id].present? && params[:task_id].to_i > 0
    end
    
    def remove_fields_if_not_need_delivery
      params[:task_request].delete :what_to_deliver
      params[:task_request].delete :delivery_instruction
    end
  end
end
