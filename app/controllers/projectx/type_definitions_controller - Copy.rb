require_dependency "projectx/application_controller"

module Projectx
  class TypeDefinitionsController < ApplicationController
    before_filter :require_signin
    before_filter :require_employee
    before_filter :require_for_what
    
    def index
      @title = 'Index' + params[:for_what].capitalize + ' Type'
      if grant_access?('index_global','projectx_type_definitions') || grant_access?('index_regional','projectx_type_definitions') || grant_access?('index','projectx_type_definitions')
        @type_definitions = Projectx::TypeDefinition.where(:for_what => params[:for_what]).order('active DESC, ranking_order')
        puts @type_definitions
      else
        @type_definitions = Projectx::TypeDefinition.where(:active => true).where(:for_what => params[:for_what]).order('ranking_order')
      end
    end
  
    def new
      @title = 'New ' + params[:for_what].capitalize + ' Type'
      if grant_access?('create','projectx_type_definitions')
        @type_definition = Projectx::TypeDefinition.new
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def create
      if grant_access?('create','projectx_type_definitions')
        @type_definition = Projectx::TypeDefinition.new(params[:project_type], :as => :role_new)
        @type_definition.for_what = params[:for_what]
        @type_definition.last_updated_by_id = session[:user_id]
        if @type_definition.save
          redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Type Definition Saved!")
        else
          flash.now[:error] = 'Data Error. Not Saved!'
          render 'new'
        end
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")     
      end
    end
  
    def edit
      @title = 'Update ' + params[:for_what].capitalize + ' Type'
      if grant_access?('update',"projectx_type_definitions")
        @type_definition = Projectx::TypeDefinition.find_by_id(params[:id])
      else
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end
    end
  
    def update
      if  !grant_access?('update','projectx_type_definitions')
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      else
        @type_definition = Projectx::TypeDefinition.find_by_id(params[:id])
        @type_definition.last_updated_by_id = session[:user_id]
        if @type_definition.update_attributes(params[:type_definition], :as => :role_update)
          #redirect_to type_definitions_path, :notice => params[:for_what].capitalize + "Type Definition Updated!"
          redirect_to URI.escape(SUBURI + '/authentify/view_handler?index=0&msg=' + params[:for_what].capitalize + ' Type Definition Updated!')
        else
          flash.now[:error] = 'Data Error. Not Updated!'
          render 'edit'
        end
      end
    end

    def show
      if !grant_access?('show', 'projectx_type_definitions')
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Insufficient Right!")
      end

      @title = 'Type Definition Info'
      @type_definition = Projectx::TypeDefinition.find(params[:id])
    end



    protected
    def require_for_what
      return true if params[:for_what].present?
      flash.now[:error] = 'Missing Data (for_what)!'
      return false
    end
  end
end
