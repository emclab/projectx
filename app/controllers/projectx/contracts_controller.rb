require_dependency "projectx/application_controller"

module Projectx
  class ContractsController < ApplicationController
    
    prepend_before_filter :require_signin, :require_employee


    def index
      @title = 'Contract'
      @contracts = Projectx::Contract.order('active DESC, ranking_order')
      @contracts = paginate(@contracts)
    end
  
    def new
      @title = 'New Contract'
      @contract = Projectx::Contract.new
    end
  
    def create
      @contract = Projectx::Contract.new(params[:contract], :as => :role_new)
      @contract.last_updated_by_id = session[:user_id]
      if @contract.save
        redirect_to contract_path, :notice => 'New Contract Saved!'
      else
        flash.now[:error] = 'Data Error. Not Saved!'
        render 'new'
      end
    end
  
    def edit
      @title = 'Update Contract'
      @contract = Projectx::Contract.find_by_id(params[:id])
    end
  
    def update
      @contract = Projectx::TaskDefinition.find_by_id(params[:id])
      @contract.last_updated_by_id = session[:user_id]
      if @contract.update_attributes(params[:contract], :as => :role_update)
        redirect_to contracts_path, :notice => 'Update Contract Updated!'
      else
        flash.now[:error] = 'Data Error. Not Updated!'
        render 'edit'
      end
    end
    
  end
end
