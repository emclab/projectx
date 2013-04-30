# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class TaskDefinitionsController < ApplicationController
    
    prepend_before_filter :require_employee

    def index
      @title = 'Task Definition'
      @task_definitions = params[:projectx_task_definitions][:model_ar_r].page(params[:page]).per_page(@max_pagination)     
    end
  
    def new
      @title = 'New Task Definition'
      @task_definition = Projectx::TaskDefinition.new
    end
  
    def create
      @task_definition = Projectx::TaskDefinition.new(params[:task_definition], :as => :role_new)
      @task_definition.last_updated_by_id = session[:user_id]
      if @task_definition.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=New Task Definition Saved!")
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = 'Update Task Definition'
      @task_definition = Projectx::TaskDefinition.find_by_id(params[:id])
    end
  
    def update
      @task_definition = Projectx::TaskDefinition.find_by_id(params[:id])
      @task_definition.last_updated_by_id = session[:user_id]
      if @task_definition.update_attributes(params[:task_definition], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Task Definition Updated!")
      else
        flash.now[:error] = 'Data Error. Not Updated!'
        render 'edit'
      end
    end
    
  end
end
