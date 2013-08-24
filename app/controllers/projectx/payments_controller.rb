require_dependency "projectx/application_controller"

module Projectx
  class PaymentsController < ApplicationController
    prepend_before_filter :require_employee
    before_filter :load_contract


    def index
      @title = 'Payments'
      if @contract
        @payments = @contract.payments.page(params[:page]).per_page(@max_pagination)
      else
        @payments = params[:projectx_payments][:model_ar_r].page(params[:page]).per_page(@max_pagination)
      end
      @erb_code = find_config_const('payment_index_view', 'projectx')
    end


    def new
      @title = 'New Payment'
      @payment = @contract.payments.new
      #@payment.contract_id = params[:contract_id]
    end


    def create
      #@payment = Projectx::Payment.new(params[:payment], :as => :role_new)
      @payment = @contract.payments.new(params[:payment], :as => :role_new)
      @payment.last_updated_by_id = session[:user_id]
      if @payment.save
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Payment Successfully Saved!")
      else
        flash[:notice] = 'Data error. Payment Not Saved!'
        render 'new'
      end
    end

    def edit
      @title = 'Edit Payment'
      @payment = Projectx::Payment.find_by_id(params[:id])
    end

    def update
      @payment = Projectx::Payment.find_by_id(params[:id])
      @payment.last_updated_by_id = session[:user_id]
      if @payment.update_attributes(params[:payment], :as => :role_update)
        redirect_to URI.escape(SUBURI + "/authentify/view_handler?index=0&msg=Payment Successfully Updated!")
      else
        flash[:notice] = 'Data error. Payment No Saved!'
        render 'edit'
      end
    end

    def show
      @title = 'Payment Info'
      @payment = Projectx::Payment.find_by_id(params[:id])
      @erb_code = find_config_const('payment_show_view', 'projectx')
    end

=begin
    def search
      @title = 'Payment Search'
      @payment = Projectx::Payment.new()
    end

    def search_results
      @title = 'Payment Search Results'
      @payments = apply_search_criteria(params[:projectx_payments][:model_ar_r], params)
      @payments = @payments.page(params[:page]).per_page(@max_pagination)
      @search_params = search_params()
    end
=end

    def autocomplete
      @payments = Projectx::Payment.where("active = ?", true).order(:name).where("name like ?", "%#{params[:term]}%")
      render json: @payments.map(&:name)
    end


    protected
    
    
=begin
    def search_params
      search_params = 'Search Parameters:'
      search_params += ', Contract Id:' + params[:contract_id_s] if params[:contract_id_s].present?
      search_params += ', Received After Date:' + params[:received_after_date_s] if params[:received_after_date_s].present?
      search_params += ', Received Before Date:' + params[:received_before_date_s] if params[:received_before_date_s].present?
      search_params += ', Received By:' + params[:received_by_id_s] if params[:received_by_id_s].present?
      search_params += ', Payed By:' + params[:paid_by_id_s] if params[:paid_by_id_s].present?
      search_params += ', Payment Type' + params[:payment_type_s] if params[:payment_type_s].present?
      search_params
    end


    def apply_search_criteria(payments, params)
      payments = payments.where("id = ?", params[:payment_id_s]) if params[:payment_id_s].present?
      payments = payments.where("contract_id = ?", params[:contract_id_s]) if params[:contract_id_s].present?
      payments = payments.where('received_date > ?', params[:received_after_date_s]) if params[:received_after_date_s].present?
      payments = payments.where('received_date < ?', params[:received_before_date_s]) if params[:received_before_date_s].present?
      payments = payments.where(:received_by_id => params[:received_by_id_s] ) if params[:received_by_id_s].present?
      payments = payments.where(:paid_by_id => params[:paid_by_id_s]) if params[:paid_by_id_s].present?
      payments = payments.where(:payment_type => params[:payment_type_s]) if params[:payment_type_s].present?
      payments
    end
=end

    #def apply_pagination(payments)
    #  max_entries_page = find_config_const('pagination')
     # payments = payments.page(params[:page]).per_page(max_entries_page).order("received_date DESC")
    #  payments.all()
    #end
    
    def load_contract
      @contract = Projectx::Contract.find_by_id(params[:contract_id]) if params[:contract_id].present? && params[:contract_id].to_i > 0
    end

  end
end
