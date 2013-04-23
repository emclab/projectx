# encoding: UTF-8
# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# Note that this schema.rb definition is the authoritative source for your
# database schema. If you need to create the application database on another
# system, you should be using db:schema:load, not running all the migrations
# from scratch. The latter is a flawed and unsustainable approach (the more migrations
# you'll amass, the slower it'll run and the greater likelihood for issues).
#
# It's strongly recommended to check this file into your version control system.

ActiveRecord::Schema.define(:version => 20130421220242) do

  create_table "authentify_engine_configs", :force => true do |t|
    t.string   "engine_name"
    t.string   "engine_version"
    t.string   "argument_name"
    t.string   "argument_value"
    t.integer  "last_updated_by_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "authentify_group_types", :force => true do |t|
    t.string   "name"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  create_table "authentify_role_definitions", :force => true do |t|
    t.string   "name"
    t.string   "brief_note"
    t.integer  "last_updated_by_id"
    t.integer  "manager_role_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "authentify_sessions", :force => true do |t|
    t.string   "session_id", :null => false
    t.text     "data"
    t.datetime "created_at", :null => false
    t.datetime "updated_at", :null => false
  end

  add_index "authentify_sessions", ["session_id"], :name => "index_authentify_sessions_on_session_id"
  add_index "authentify_sessions", ["updated_at"], :name => "index_authentify_sessions_on_updated_at"

  create_table "authentify_sys_logs", :force => true do |t|
    t.datetime "log_date"
    t.integer  "user_id"
    t.string   "user_name"
    t.string   "user_ip"
    t.string   "action_logged"
  end

  create_table "authentify_sys_module_mappings", :force => true do |t|
    t.integer  "sys_module_id"
    t.integer  "sys_user_group_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "authentify_sys_modules", :force => true do |t|
    t.string   "module_name"
    t.string   "module_group_name"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "authentify_sys_user_groups", :force => true do |t|
    t.string   "user_group_name"
    t.string   "short_note"
    t.integer  "zone_id"
    t.integer  "group_type_id"
    t.integer  "manager_group_id"
    t.datetime "created_at",       :null => false
    t.datetime "updated_at",       :null => false
  end

  create_table "authentify_user_accesses", :force => true do |t|
    t.string   "right"
    t.string   "action"
    t.string   "resource"
    t.string   "resource_type"
    t.string   "brief_note"
    t.integer  "last_updated_by_id"
    t.integer  "role_definition_id"
    t.text     "sql_code"
    t.text     "masked_attrs"
    t.integer  "rank"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "authentify_user_levels", :force => true do |t|
    t.integer  "user_id"
    t.integer  "sys_user_group_id"
    t.datetime "created_at",        :null => false
    t.datetime "updated_at",        :null => false
  end

  create_table "authentify_user_roles", :force => true do |t|
    t.integer  "last_updated_by_id"
    t.integer  "role_definition_id"
    t.integer  "user_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "authentify_users", :force => true do |t|
    t.string   "name"
    t.string   "email"
    t.string   "login"
    t.string   "encrypted_password"
    t.string   "salt"
    t.string   "status",                 :default => "active"
    t.integer  "last_updated_by_id"
    t.integer  "customer_id"
    t.string   "auth_token"
    t.string   "password_reset_token"
    t.datetime "password_reset_sent_at"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "authentify_zones", :force => true do |t|
    t.string   "zone_name"
    t.string   "brief_note"
    t.boolean  "active",        :default => true
    t.integer  "ranking_order"
    t.datetime "created_at",                      :null => false
    t.datetime "updated_at",                      :null => false
  end

  create_table "customerx_addresses", :force => true do |t|
    t.string   "province"
    t.string   "city_county_district"
    t.string   "add_line"
    t.integer  "customer_id"
    t.datetime "created_at",           :null => false
    t.datetime "updated_at",           :null => false
  end

  create_table "customerx_contacts", :force => true do |t|
    t.integer  "customer_id"
    t.string   "name"
    t.string   "position"
    t.string   "phone"
    t.string   "cell_phone"
    t.string   "email"
    t.text     "brief_note"
    t.datetime "created_at",  :null => false
    t.datetime "updated_at",  :null => false
  end

  create_table "customerx_customer_comm_records", :force => true do |t|
    t.integer  "customer_id"
    t.string   "via"
    t.string   "subject"
    t.text     "contact_info"
    t.text     "content"
    t.integer  "last_updated_by_id"
    t.integer  "comm_category_id"
    t.integer  "reported_by_id"
    t.date     "comm_date"
    t.boolean  "void",               :default => false
    t.boolean  "boolean",            :default => false
    t.datetime "created_at",                            :null => false
    t.datetime "updated_at",                            :null => false
  end

  create_table "customerx_customers", :force => true do |t|
    t.string   "name"
    t.string   "short_name"
    t.date     "since_date"
    t.text     "shipping_instruction"
    t.integer  "zone_id"
    t.integer  "customer_status_category_id"
    t.string   "phone"
    t.string   "fax"
    t.integer  "sales_id"
    t.boolean  "active",                      :default => true
    t.integer  "last_updated_by_id"
    t.integer  "quality_system_id"
    t.string   "employee_num"
    t.string   "revenue"
    t.text     "customer_eval"
    t.text     "main_biz"
    t.text     "customer_taste"
    t.text     "note"
    t.string   "web"
    t.datetime "created_at",                                    :null => false
    t.datetime "updated_at",                                    :null => false
  end

  create_table "customerx_logs", :force => true do |t|
    t.integer  "sales_lead_id"
    t.integer  "customer_comm_record_id"
    t.integer  "last_updated_by_id"
    t.text     "log"
    t.datetime "created_at",              :null => false
    t.datetime "updated_at",              :null => false
  end

  create_table "customerx_misc_definitions", :force => true do |t|
    t.string   "name"
    t.text     "brief_note"
    t.boolean  "active",             :default => true
    t.integer  "ranking_order"
    t.integer  "last_updated_by_id"
    t.string   "for_which"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "customerx_sales_leads", :force => true do |t|
    t.integer  "customer_id"
    t.integer  "last_updated_by_id"
    t.integer  "provider_id"
    t.text     "lead_info"
    t.text     "contact_instruction"
    t.string   "lead_status"
    t.text     "lead_eval"
    t.boolean  "sale_success"
    t.boolean  "close_lead"
    t.datetime "close_lead_date"
    t.integer  "close_lead_by_id"
    t.integer  "lead_source_id"
    t.integer  "lead_quality"
    t.integer  "lead_accuracy"
    t.string   "subject"
    t.date     "lead_date"
    t.integer  "initial_order_total"
    t.datetime "created_at",          :null => false
    t.datetime "updated_at",          :null => false
  end

  create_table "projectx_contracts", :force => true do |t|
    t.integer  "project_id"
    t.decimal  "contract_amount",    :precision => 10, :scale => 2
    t.decimal  "other_charge",       :precision => 10, :scale => 2
    t.string   "payment_term"
    t.boolean  "paid_out",                                          :default => false
    t.boolean  "signed",                                            :default => false
    t.date     "sign_date"
    t.integer  "signed_by_id"
    t.boolean  "contract_on_file",                                  :default => false
    t.integer  "last_updated_by_id"
    t.datetime "created_at",                                                           :null => false
    t.datetime "updated_at",                                                           :null => false
  end

  create_table "projectx_logs", :force => true do |t|
    t.integer  "task_request_id"
    t.integer  "project_id"
    t.integer  "task_id"
    t.text     "log"
    t.integer  "last_updated_by_id"
    t.datetime "created_at",         :null => false
    t.datetime "updated_at",         :null => false
  end

  create_table "projectx_misc_definitions", :force => true do |t|
    t.string   "name"
    t.boolean  "active",             :default => true
    t.string   "for_which"
    t.text     "brief_note"
    t.integer  "last_updated_by_id"
    t.integer  "ranking_order"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "projectx_project_task_templates", :force => true do |t|
    t.string   "name"
    t.integer  "type_definition_id"
    t.integer  "last_updated_by_id"
    t.boolean  "active",             :default => true
    t.text     "instruction"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "projectx_projects", :force => true do |t|
    t.string   "name"
    t.string   "project_num"
    t.integer  "customer_id"
    t.integer  "project_task_template_id"
    t.text     "project_desp"
    t.integer  "sales_id"
    t.date     "start_date"
    t.date     "end_date"
    t.date     "delivery_date"
    t.date     "estimated_delivery_date"
    t.text     "project_instruction"
    t.integer  "project_manager_id"
    t.boolean  "cancelled",                :default => false
    t.boolean  "completed",                :default => false
    t.integer  "last_updated_by_id"
    t.boolean  "expedite",                 :default => false
    t.integer  "status_id"
    t.datetime "created_at",                                  :null => false
    t.datetime "updated_at",                                  :null => false
  end

  create_table "projectx_task_definitions", :force => true do |t|
    t.string   "name"
    t.string   "task_desp"
    t.text     "task_instruction"
    t.integer  "last_updated_by_id"
    t.integer  "ranking_order"
    t.boolean  "active",             :default => true
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

  create_table "projectx_task_requests", :force => true do |t|
    t.string   "name"
    t.integer  "task_id"
    t.date     "request_date"
    t.boolean  "expedite",             :default => false
    t.date     "expected_finish_date"
    t.text     "request_content"
    t.boolean  "need_delivery",        :default => false
    t.text     "what_to_deliver"
    t.text     "delivery_instruction"
    t.integer  "requested_by_id"
    t.integer  "last_updated_by_id"
    t.boolean  "completed",            :default => false
    t.boolean  "cancelled",            :default => false
    t.integer  "request_status_id"
    t.datetime "created_at",                              :null => false
    t.datetime "updated_at",                              :null => false
  end

  create_table "projectx_task_templates", :force => true do |t|
    t.integer  "project_task_template_id"
    t.integer  "task_definition_id"
    t.integer  "execution_order"
    t.integer  "execution_sub_order"
    t.boolean  "start_before_previous_completed", :default => false
    t.text     "brief_note"
    t.boolean  "need_request",                    :default => false
    t.datetime "created_at",                                         :null => false
    t.datetime "updated_at",                                         :null => false
  end

  create_table "projectx_tasks", :force => true do |t|
    t.integer  "project_id"
    t.text     "brief_note"
    t.integer  "assigned_to_id"
    t.boolean  "cancelled",                 :default => false
    t.boolean  "completed",                 :default => false
    t.boolean  "expedite",                  :default => false
    t.boolean  "skipped",                   :default => false
    t.date     "finish_date"
    t.date     "start_date"
    t.integer  "task_status_definition_id"
    t.integer  "task_template_id"
    t.integer  "last_updated_by_id"
    t.datetime "created_at",                                   :null => false
    t.datetime "updated_at",                                   :null => false
  end

  create_table "projectx_type_definitions", :force => true do |t|
    t.string   "name"
    t.boolean  "active",             :default => true
    t.text     "brief_note"
    t.integer  "last_updated_by_id"
    t.integer  "ranking_order"
    t.datetime "created_at",                           :null => false
    t.datetime "updated_at",                           :null => false
  end

end
