require_dependency "projectx/application_controller"

module Projectx
  class ContractsController < ApplicationController
    
    prepend_before_filter :require_signin, :require_employee


    def index
      @title = 'Contract'
      @contracts = find_contracts(params[:projectx_contracts][:model_ar_r])
    end


    def new
      @title = 'New Contract'
      @contract = Projectx::Contract.new
    end


    def create
      @contract = Projectx::Contract.new(params[:contract], :as => :role_new)
      @contract.last_updated_by_id = session[:user_id]
      if @contract.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Contract Successfully Saved!")
      else
        flash.now[:error] = 'Data Error. Contract Not Saved!'
        render 'new'
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


    def search
      @title = 'Contract Search'
      @contract = Projectx::Contract.new()
    end

    def search_results
      @title = 'Contract Search Results'
      @contracts = find_contracts(params[:projectx_contracts][:model_ar_r])
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
      search_params
    end

    def find_contracts(contracts)
      max_page = find_const('pagination').argument_value
      contracts = contracts.page(params[:page]).per_page(max_page).order("expedite DESC, zone_id, id DESC, start_date DESC")
      contracts.all()
    end


  end
end
