#encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class ProjectsController < ApplicationController
    prepend_before_filter :require_employee


    def index
      @title = 'Projects'
      @projects = apply_pagination(params[:projectx_projects][:model_ar_r])
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
    end


    def search
      @title = 'Project Search'
      @project = Projectx::Project.new()
    end

    def search_results
      @title = 'Project Search Results'
      @projects = apply_search_criteria(params[:projectx_projects][:model_ar_r], params)
      @projects = apply_pagination(@projects)
      @search_params = search_params()
    end


    def autocomplete
      @projects = Projectx::Project.where("active = ?", true).order(:name).where("name like ?", "%#{params[:term]}%")
      render json: @projects.map(&:name)
    end


    protected

    def search_params
      search_params = 'Search Parameters:'
      search_params += ', Keyword:' + params[:keyword] if params[:keyword].present?
      search_params += ', Start Date:' + params[:start_date_s] if params[:start_date_s].present?
      search_params += ', End Date:' + params[:end_date_s] if params[:end_date_s].present?
      search_params += ', Customer Id:' + params[:customer_id_s] if params[:customer_id_s].present?
      search_params += ', Status:' + params[:status_id_s] if params[:status_id_s].present?
      search_params += ', Zone:' + params[:zone_id_s] if params[:zone_id_s].present?
      search_params += ', Expedite:' + params[:expedite_s] if params[:expedite_s].present?
      search_params += ', Completion %:' + params[:completion_percent_s] if params[:completion_percent_s].present?
      search_params += ', Sales:' +  params[:sales_id_s] if params[:sales_id_s].present?
      search_params += ', Payment %:' +  params[:payment_percent_s] if params[:payment_percent_s].present?
      search_params += ', Project Type:' + params[:project_task_template_id_s] if params[:project_task_template_id_s].present?
      search_params
    end


    def apply_search_criteria(projects, params)
      projects = projects.where("id = ?", params[:project_id_s]) if params[:project_id_s].present?
      projects = projects.where("name like ? ", "%#{params[:keyword]}%") if params[:keyword].present?
      projects = projects.where('created_at > ?', params[:start_date_s]) if params[:start_date_s].present?
      projects = projects.where('created_at < ?', params[:end_date_s]) if params[:end_date_s].present?
      projects = projects.where(:customer_id => params[:customer_id_s] ) if params[:customer_id_s].present?
      projects = projects.where(:status => params[:status_s]) if params[:status_s].present?
      projects = projects.where(:expedite => params[:expedite_s]) if params[:expedite_s].present?
      projects = projects.where(:completion_percent => params[:completion_percent_s]) if params[:completion_percent_s].present?
      projects = projects.joins(:customer).where(:customerx_customers => {:zone_id => params[:zone_id_s]}) if params[:zone_id_s].present?
      projects = projects.where(:sales_id => params[:sales_id_s]) if params[:sales_id_s].present?
      projects = projects.where(:project_task_template_id => params[:project_task_template_id_s]) if params[:project_task_template_id_s].present?
      projects = projects.where(:payment_percent => params[:payment_percent_s]) if params[:payment_percent_s].present?
      projects
    end

    def apply_pagination(projects)
      max_entries_page = find_config_const('pagination')
      projects = projects.page(params[:page]).per_page(max_entries_page).order("expedite DESC, id DESC, start_date DESC")
      projects.all()
    end
    
  end


end
