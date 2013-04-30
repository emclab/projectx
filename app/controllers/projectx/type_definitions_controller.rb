# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class TypeDefinitionsController < ApplicationController
    before_filter :require_employee
    
    def index
    @title = '项目类型一览'
      @type_definitions = params[:projectx_type_definitions][:model_ar_r].page(params[:page]).per_page(@max_pagination)     
    end
  
    def new
      @title = '新项目类型'
      @type_definition = Projectx::TypeDefinition.new
    end
  
    def create
      @type_definition = Projectx::TypeDefinition.new(params[:type_definition], :as => :role_new)
      @type_definition.last_updated_by_id = session[:user_id]
      if @type_definition.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=New Type Definition Saved!")
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = '更新项目类型'
      @type_definition = Projectx::TypeDefinition.find_by_id(params[:id])
    end
  
    def update
      @type_definition = Projectx::TypeDefinition.find_by_id(params[:id])
      @type_definition.last_updated_by_id = session[:user_id]
      if @type_definition.update_attributes(params[:type_definition], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Type Definition Updated!")
      else
        flash.now[:error] = 'Data Error. Not Updated!'
        render 'edit'
      end
    end
  end
end
