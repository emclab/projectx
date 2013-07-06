# encoding:utf-8
require_dependency "projectx/application_controller"

module Projectx
  class LogsController < ApplicationController
    before_filter :require_employee
    before_filter :load_project
    before_filter :load_task
    before_filter :load_task_request
    before_filter :require_which_table, :only => [:index, :new, :create] 
    before_filter :load_session_variable, :only => [:new, :edit]
    after_filter :delete_session_variable, :only => [:create, :update] 
    
    def index
      if @project
        @logs = @project.logs.page(params[:page]).per_page(@max_pagination).order('id DESC')
      elsif @task
        @logs = @task.logs.page(params[:page]).per_page(@max_pagination).order('id DESC')
      elsif @task_request
        @logs = @task_request.logs.page(params[:page]).per_page(@max_pagination).order('id DESC')
      elsif @which_table 
        @logs = params[:projectx_logs][:model_ar_r].page(params[:page]).per_page(@max_pagination)
      else
        #@which_table does not match any
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Parental Object Name Not Match!")
      end
    end
  
    def new
      #session[:which_table] = @which_table
      #session[:subaction] = @which_table
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
      #session.delete(:subaction) #subaction used in check_access_right in authentify
      if session[:which_table] == 'project' && @project
        @log = @project.logs.new(params[:log], :as => :role_new)
        data_save = true
      elsif session[:which_table] == 'task' && @task
        @log = @task.logs.new(params[:log], :as => :role_new)
        data_save = true
      elsif session[:which_table] == 'task_request' && @task_request
        @log = @task_request.logs.new(params[:log], :as => :role_new)
        data_save = true
      else
        #session.delete(:which_table)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=NO parental object selected!")
      end
      #session.delete(:which_table)
      if data_save  #otherwise @log.save will be executed no matter what.
        @log.last_updated_by_id = session[:user_id]
        if @log.save
          redirect_to project_path(@project) if @project
          redirect_to project_task_path(@task.project, @task) if @task
          redirect_to task_task_request_path(@task_request.task, @task_request) if @task_request
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      end
    end
    
    protected
    
    def require_which_table
      @which_table = session[:which_table] if session[:which_table].present?
      @which_table = params[:which_table] if params[:which_table].present?  #should be after session     
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
      @task_request = Projectx::TaskRequest.find_by_id(params[:task_request_id]) if params[:task_request_id].present? &&                                                                                    params[:task_request_id].to_i > 0
    end
 

  end
end
