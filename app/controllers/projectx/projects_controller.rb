#encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class ProjectsController < ApplicationController
    prepend_before_filter :require_signin, :require_employee


    def index
      @title = 'Projects'
      @projects = find_projects(params[:projectx_projects][:model_ar_r])
    end


    def new
      @title = 'New Project'
      @project = Projectx::Project.new
      #@project.contract.build
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
    end

    def autocomplete
      @projects = Projectx::Project.where("active = ?", true).order(:name).where("name like ?", "%#{params[:term]}%")
      render json: @projects.map(&:name)
    end

    def search
      @title = 'Project Search'
      @project = Projectx::Project.new()
    end

    def search_results
      @title = 'Project Search Results'
      @projects = find_projects(params[:projectx_projects][:model_ar_r])
      #seach params
      @search_params = search_params()
    end
    
    protected
    
    def search_params
      search_params = "参数："
      search_params += ' 开始日期：' + params[:start_date_s] if params[:start_date_s].present?
      search_params += ', 结束日期：' + params[:end_date_s] if params[:end_date_s].present?
      search_params += ', 关键词 ：' + params[:keyword] if params[:keyword].present?
      search_params += ', 片区 ：' + Authentify::Zone.find_by_id(params[:zone_id_s].to_i).zone_name if params[:zone_id_s].present?
      search_params += ', 业务员 ：' + Authentify::User.find_by_id(params[:sales_id_s].to_i).name if params[:sales_id_s].present?
      search_params += ', Status ：' + Projectx::MiscDefinition.find_by_id(params[:sales_id_s].to_i).name if params[:status_id_s].present?
      search_params += ', Type ：' + Projectx::ProjectTaskTemplate.find_by_id(params[:project_task_template_id_s].to_i).name if params[:project_task_template_id_s].present?
      search_params
    end
    
    def find_projects(projects)
      max_page = find_const('pagination').argument_value
      projects = projects.page(params[:page]).per_page(max_page).order("expedite DESC, id DESC, start_date DESC")
      projects.all()
    end
    
  end


end
