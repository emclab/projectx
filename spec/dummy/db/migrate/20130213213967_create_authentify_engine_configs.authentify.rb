# This migration comes from authentify (originally 20130205011640)
class CreateAuthentifyEngineConfigs < ActiveRecord::Migration
  def change
    create_table :authentify_engine_configs do |t|
      #t.integer     :client_id
      t.string      :engine_name
      t.string      :engine_version
      t.string      :argument_name
      t.string      :argument_value
      t.integer     :last_updated_by_id
      t.timestamps
    end
  end
end
