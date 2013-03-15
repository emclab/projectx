#encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class ProjectsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee


    def index
      @title = 'Projects'
      has_right = true
      params[:project] = {}  #instanciate the params object
      if grant_access?('index', 'projectx_projects')
        params[:project] = {}        
      elsif grant_access?('index_zone', 'projectx_projects')
        params[:project][:zone_id_s] = session[:user_privilege].user_zone_ids
      elsif grant_access?('index_individual', 'projectx_projects')
        params[:project][:sales_id_s] = session[:user_id]

      else
        has_right = false
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")    
      end
      #return @projects if has right     
      if has_right
        project = Projectx::Project.new(params[:project], :as => :role_search_stats)
        @projects = find_projects(project)
      end
    end


    def new
      if !grant_access?('create', 'projectx_projects')
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      else
        @title = 'New Project'
        @project = Projectx::Project.new
        @project.contracts.build
      end
    end

    def create
      if !grant_access?('create', 'projectx_projects')
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      else
        @project = Projectx::Project.new(params[:project], :as => :role_new)
        @project.last_updated_by_id = session[:user_id]
        if @project.save
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Project Saved!")
        else
          flash[:notice] = 'Data error. NOT Saved!'
          render 'new'
        end
      end
    end

    def edit
      if !grant_access?('update', 'projectx_projects')
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
      @title = 'Edit Project'
      @project = Projectx::Project.find(params[:id])
    end

    def update
      if !grant_access?('update', 'projectx_projects')
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      else
        @project = Projectx::Project.find(params[:id])
        @project.last_updated_by_id = session[:user_id]
        if @project.update_attributes(params[:project], :as => :role_update)
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Project Update Saved!")
        else
          flash[:notice] = 'Data error. NOT Saved!'
          render 'edit'
        end
      end
    end

    def show
      if !grant_access?('show', 'projectx_projects')
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end

      @title = 'Project Info'
      @project = Projectx::Project.find(params[:id])
    end
    
    def autocomplete
      @projects = Projectx::Project.where("active = ?", true).order(:name).where("name like ?", "%#{params[:term]}%")
      render json: @projects.map(&:name)    
    end  
    
    def search
      if grant_access?('search_individual', 'projectx_projects') || grant_access?('search_regional', 'projectx_projects') || grant_access?('search_global', 'projectx_projects')
        @project = Projectx::Project.new()
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end

    def search_results
      @projects = Projectx::Project.new(params[:project], :as => :role_search_stats)
      @projects = @projects.find_projects()
      if grant_access?('search_individual', 'projectx_projects') || grant_access?('search_regional' , 'projectx_projects') || grant_access?('search_global', 'projectx_projects')
        @projects = sort_projects(@projects)
        #seach params
        @search_params = search_params()
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
    
    protected
    
    def sort_projects(projects)
      if grant_access?('search_global', 'projectx_projects')
        projects
      elsif grant_access?('search_regional', 'projectx_projects')
        user_zone_ids = session[:user_priviledge].user_zones
        projects = projects.where(:project => {:zone_id => user_zone_ids})
      elsif grant_access?('search_individual', 'projectx_projects')
        projects = projects.where("projectx_projects.sales_id = ?", session[:user_id])
      else
        projects = []
      end
      projects.page(params[:page]).per_page(30)
    end
    
    def search_params
      search_params = "参数："
      search_params += ' 开始日期：' + params[:project][:start_date_s] if params[:project][:start_date_s].present?
      search_params += ', 结束日期：' + params[:project][:end_date_s] if params[:project][:end_date_s].present?
      search_params += ', 关键词 ：' + params[:project][:keyword] if params[:project][:keyword].present?
      search_params += ', 片区 ：' + Authentify::Zone.find_by_id(params[:project][:zone_id_s].to_i).zone_name if params[:project][:zone_id_s].present?
      search_params += ', 业务员 ：' + Authentify::User.find_by_id(params[:project][:sales_id_s].to_i).name if params[:project][:sales_id_s].present?
      search_params
    end
    
    def find_projects(project)
      projects = project.find_projects.page(params[:page]).per_page(30).order("expedite DESC, zone_id, id DESC, start_date DESC")
      return projects if projects.blank?  
      projects = projects.all()
    end
    
  end
end
