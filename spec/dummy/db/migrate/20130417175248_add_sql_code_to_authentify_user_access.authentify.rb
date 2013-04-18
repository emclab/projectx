# This migration comes from authentify (originally 20130321192627)
class AddSqlCodeToAuthentifyUserAccess < ActiveRecord::Migration
  def change
    add_column :authentify_user_accesses, :sql_code, :text
  end
end
