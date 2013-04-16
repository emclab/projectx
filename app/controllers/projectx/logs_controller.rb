# encoding:utf-8
require_dependency "projectx/application_controller"

module Projectx
  class LogsController < ApplicationController
    before_filter :require_employee
    before_filter :load_project
    before_filter :load_task
    before_filter :load_task_request
    before_filter :require_which_table, :only => [:index, :new, :create] 
    
    def index
      if @project
        @logs = @project.logs.page(params[:page]).per_page(30).order('id DESC')
      elsif @task
        @logs = @task.logs.page(params[:page]).per_page(30).order('id DESC')
      elsif @task_request
        @logs = @task_request.logs.page(params[:page]).per_page(30).order('id DESC')
      elsif @which_table == 'task'
        @logs = params[:projectx_logs][:model_ar_r].where("projectx_logs.task_id > ?", 0).page(params[:page]).per_page(30)
      elsif @which_table == 'project'
        @logs = params[:projectx_logs][:model_ar_r].where("projectx_logs.project_id > ?", 0).page(params[:page]).per_page(30)
      elsif @which_table == 'task_request'
        @logs = params[:projectx_logs][:model_ar_r].where("projectx_logs.task_request_id > ?", 0).page(params[:page]).per_page(30)
      else
        #@which_table does not match any
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Parental Object Name Not Match!")
      end
    end
  
    def new
      if @which_table == 'project' 
        if  @project
          @log = @project.logs.new()
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO project selected for log!")
        end
      elsif @which_table == 'task' #&& grant_access?('create_customer_comm_record', 'customerx_logs')
        if @task
          @log = @task.logs.new()
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO task selected for log!")
        end
      elsif @which_table == 'task_request'
        if @task_request
          @log= @task_request.logs.new()
        else
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO task reqeust selected for log!")
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient right!")  
      end
    end
  
    def create
      if params[:which_table] == 'project' && @project
        @log = @project.logs.new(params[:log], :as => :role_new)
        data_save = true
      elsif params[:which_table] == 'task' && @task
        @log = @task.logs.new(params[:log], :as => :role_new)
        data_save = true
      elsif params[:which_table] == 'task_request' && @task_request
        @log = @task_request.logs.new(params[:log], :as => :role_new)
        data_save = true
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO parental object selected!")
      end
      if data_save  #otherwise @log.save will be executed no matter what.
        @log.last_updated_by_id = session[:user_id]
        if @log.save
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Log Saved!")
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      end
    end
    
    protected
    
    def require_which_table
      @which_table = params[:which_table]
      unless @which_table == 'project' || @which_table == 'task' || @which_table == 'task_request'
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Initial Params Error!") 
      end
    end
  
    def load_project
      @project = Projectx::Project.find_by_id(params[:project_id]) if params[:project_id].present? &&
                                                                      params[:project_id].to_i > 0
    end
    
    def load_task
      @task = Projectx::Task.find_by_id(params[:task_id]) if params[:task_id].present? &&
                                                             params[:task_id].to_i > 0
    end
    
    def load_task_request
      @task_request = Projectx::TaskRequest.find_by_id(params[:task_request_id]) if params[:task_request_id].present? &&
                                                                                    params[:task_request_id].to_i > 0
    end
  end
end
