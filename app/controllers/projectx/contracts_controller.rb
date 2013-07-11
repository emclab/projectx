# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class ContractsController < ApplicationController
    
    prepend_before_filter :require_employee
    before_filter :load_project


    def index
      @title = 'Contracts'
      if @project
        @contracts = Projectx::Contract.where(:project_id => @project.id).page(params[:page]).per_page(@max_pagination)  #@project.contract has pagination error
      else
        @contracts = params[:projectx_contracts][:model_ar_r].page(params[:page]).per_page(@max_pagination)
      end
    end

    def edit
      @title = 'Edit Contract'
      @contract = Projectx::Contract.find_by_id(params[:id])
    end

    def update
      @contract = Projectx::Contract.find_by_id(params[:id])
      @contract.last_updated_by_id = session[:user_id]
      if @contract.update_attributes(params[:contract], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Contract Successfully Updated!")
      else
        flash.now[:error] = 'Data Error. Contract Not Updated!'
        render 'edit'
      end
    end


    def show
      @title = 'Contract Info'
      @contract = Projectx::Contract.find_by_id(params[:id])
    end


    protected


    def load_project
      @project = Projectx::Project.find_by_id(params[:project_id]) if params[:project_id].present? && params[:project_id].to_i > 0
    end


  end
end
