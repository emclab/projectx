# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class MiscDefinitionsController < ApplicationController
    #for_which : project_type, project_status

    before_filter :require_employee
    before_filter :require_for_which, :only => [:index, :new, :edit]  
    
    helper_method 
    def index
      @title = title('index', @for_which)
      if @for_which
        @misc_definitions = params[:projectx_misc_definitions][:model_ar_r].where(:for_which => @for_which).page(params[:page]).per_page(@max_pagination)
      else
        #@for_which does not match any
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Table Name Not Match!")
      end 
    end
  
    def new
      @title = title('new', @for_which)
      params[:misc_definition] = {}
      session[:for_which] = @for_which
      session[:subaction] = params[:subaction]
      @misc_definition = Projectx::MiscDefinition.new()
    end
  
    def create
      @misc_definition = Projectx::MiscDefinition.new(params[:misc_definition], :as => :role_new)
      @misc_definition.for_which = session[:for_which] 
      session.delete(:for_which)
      session.delete(:subaction)
      @misc_definition.last_updated_by_id = session[:user_id]
      if @misc_definition.save
        redirect_to misc_definitions_path(:for_which => @misc_definition.for_which), :notice => "Definition Saved!"
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = title('edit', @for_which)
      @misc_definition = Projectx::MiscDefinition.find(params[:id])
      session[:subaction] = params[:subaction]
    end
  
    def update
      @misc_definition = Projectx::MiscDefinition.find(params[:id])
      @misc_definition.last_updated_by_id = session[:user_id]
      session.delete(:subaction)
      if @misc_definition.update_attributes(params[:misc_definition], :as => :role_update)
        redirect_to misc_definitions_path(:for_which => @misc_definition.for_which), :notice => "Definition Updated!"
      else
        flash.now[:error] = 'Data Error. Not Updated!'
        render 'edit'
      end
    end
  
    def show
    end
    
    protected
    
    def require_for_which     
      @for_which = params[:for_which] if params[:for_which].present?
      @for_which = Projectx::MiscDefinition.find_by_id(params[:id]).for_which if params[:id].present?
      unless @for_which == 'project_status' || @for_which == 'task_status' 
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Initial Params Error!") 
      end
    end
    
    def title(action, for_which)
      if action == 'index'
        return "项目状态" if for_which == 'project_status'
        return "项目任务状态" if for_which == 'task_status'
      elsif action == 'new'
        return "新项目状态" if for_which == 'project_status'
        return "新项目任务状态" if for_which == 'task_status'
      elsif action == 'edit'
        return "更新项目状态" if for_which == 'project_status'
        return "更新项目任务状态" if for_which == 'task_status'
      end
    end
  end
end
