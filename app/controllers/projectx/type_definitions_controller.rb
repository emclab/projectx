require_dependency "projectx/application_controller"

module Projectx
  class TypeDefinitionsController < ApplicationController
    prepend_before_filter :require_signin, :require_employee, :require_for_what
    
    def index
      @title = 'Index' + params[:for_what].capitalize + ' Type'
      @type_definitions = Projectx::TypeDefinition.where(:for_what => params[:for_what]).order('active DESC, ranking_order')
    end
  
    def new
      @title = 'New ' + params[:for_what].capitalize + ' Type'
      @type_definition = Projectx::TypeDefinition.new
    end
  
    def create
      @type_definition = Projectx::TypeDefinition.new(params[:project_type], :as => :role_new)
      @type_definition.for_what = params[:for_what]
      @type_definition.last_updated_by_id = session[:user_id]
      if @type_definition.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Type Definition Saved!")
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = 'Update ' + params[:for_what].capitalize + ' Type'
      @type_definition = Projectx::TypeDefinition.find_by_id(params[:id])
    end
  
    def update
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

    def show
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
