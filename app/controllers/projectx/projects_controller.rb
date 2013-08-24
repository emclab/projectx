#encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class ProjectsController < ApplicationController
    prepend_before_filter :require_employee


    def index
      @title = 'Projects'
      @projects =  params[:projectx_projects][:model_ar_r].page(params[:page]).per_page(@max_pagination)
      @erb_code = find_config_const('project_index_view', 'projectx')
    end

    def new
      @title = 'New Project'
      @project = Projectx::Project.new
      @project.build_contract
    end


    def create
      @project = Projectx::Project.new(params[:project], :as => :role_new)
      @project.last_updated_by_id = session[:user_id]
      if @project.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Project Successfully Saved!")
      else
        flash[:notice] = 'Data error. Project Not Saved!'
        render 'new'
      end
    end

    def edit
      @title = 'Edit Project'
      @project = Projectx::Project.find_by_id(params[:id])
    end

    def update
        @project = Projectx::Project.find_by_id(params[:id])
        @project.last_updated_by_id = session[:user_id]
        if @project.update_attributes(params[:project], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Project Successfully Updated!")
        else
          flash[:notice] = 'Data error. Project No Saved!'
          render 'edit'
        end
    end

    def show
      @title = 'Project Info'
      @project = Projectx::Project.find_by_id(params[:id])
      @erb_code = find_config_const('project_show_view', 'projectx')
    end




    protected


  end


end
