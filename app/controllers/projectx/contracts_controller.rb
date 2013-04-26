# encoding: utf-8
require_dependency "projectx/application_controller"

module Projectx
  class ContractsController < ApplicationController
    
    prepend_before_filter :require_signin, :require_employee


    def index
      @title = 'Contract'
      @contracts = apply_pagination(params[:projectx_contracts][:model_ar_r])
    end


    def new
      @title = 'New Contract'
      @contract = Projectx::Contract.new()
      @contract.project_id = params[:project_id]
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
      @contracts = apply_search_criteria(params[:projectx_contracts][:model_ar_r], params)
      @contracts = apply_pagination(@contracts)
      @search_params = search_params()
    end

    protected

    def search_params
      search_params = 'Search Parameters:'
      search_params += ', Start Date:' + params[:start_date_s] if params[:start_date_s].present?
      search_params += ', Contract Date:' + params[:contract_date_s] if params[:contract_date_s].present?
      search_params += ', End Date:' + params[:end_date_s] if params[:end_date_s].present?
      search_params += ', Zone:' + params[:zone_id_s] if params[:zone_id_s].present?
      search_params += ', Sales:' +  params[:sales_id_s] if params[:sales_id_s].present?
      search_params += ', Customer Id:' + params[:customer_id_s] if params[:customer_id_s].present?
      search_params += ', Paid Out:' + params[:paid_out_s] if params[:paid_out_s].present?
      search_params += ', Payment Term:' + params[:payment_term_s] if params[:payment_term_s].present?
      search_params += ', Signed:' + params[:signed_by_s] if params[:signed_by_s].present?
      search_params += ', Signed By:' + params[:signed_by_id_s] if params[:signed_by_id_s].present?
      search_params += ', Signed Date:' + params[:sales_id_s] if params[:sales_id_s].present?
      search_params += ', Contract On File?:' + params[:contract_on_file_s] if params[:contract_on_file_s].present?
      search_params
    end

    def apply_search_criteria(contracts, params)
      contracts = contracts.where("project_id = ?", params[:project_id_s].to_i) if params[:project_id_s].present?
      contracts = contracts.where(:contract_date => params[:contract_date_s]) if params[:contract_date_s].present?
      contracts = contracts.joins(:project => :customer).where(:customerx_customers => {:zone_id => params[:zone_id_s]}) if params[:zone_id_s].present?
      contracts = contracts.where(:paid_out => params[:paid_out_s]) if params[:paid_out_s].present?
      contracts = contracts.where(:payment_term => params[:payment_term_s]) if params[:payment_term_s].present?
      contracts = contracts.where(:signed => params[:signed_s]) if params[:signed_s].present?
      contracts = contracts.where(:signed_by_id => params[:signed_by_id_s]) if params[:signed_by_id_s].present?
      contracts = contracts.where(:sign_date => params[:sign_date_s]) if params[:sign_date_s].present?
      contracts = contracts.where(:contract_on_file => params[:contract_on_file_s]) if params[:contract_on_file_s].present?
      contracts
    end

    def apply_pagination(contracts)
      max_entries_page = find_config_const('pagination')
      contracts = contracts.page(params[:page]).per_page(max_entries_page).order("paid_out DESC, id DESC, sign_date DESC")
      contracts.all()
    end


  end
end
